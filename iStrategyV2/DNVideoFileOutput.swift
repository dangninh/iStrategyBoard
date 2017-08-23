//
//  DNVideoFileOutput.swift
//  iStrategyV2
//
//  Created by Dang Ninh on 22/8/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import Foundation
import AVFoundation
class DNVideoFileOutput:DNVideoOutput{
    let framePerSec = DNVideoCapture.framePerSec
    static let width = 720
    static let height = 480
    let videoOutputSettings: Dictionary<String, Any> = [
        AVVideoCodecKey : AVVideoCodecH264,
        AVVideoWidthKey : width,
        AVVideoHeightKey : height
    ];
    // You need to use BGRA for the video in order to get realtime encoding. I use a color-swizzling shader to line up glReadPixels' normal RGBA output with the movie input's BGRA.
    
    let sourcePixelBufferAttributesDictionary : [String: AnyObject] = [
        kCVPixelBufferPixelFormatTypeKey as String: NSNumber(value: kCVPixelFormatType_32BGRA),
        kCVPixelBufferWidthKey as String: NSNumber(value:width),
        kCVPixelBufferHeightKey as String: NSNumber(value:height)
    ]
    
    var currentFileURL : URL?
    var fileWriter: AVAssetWriter?
    var videoInput: AVAssetWriterInput?
    var assetWriterPixelBufferInput:AVAssetWriterInputPixelBufferAdaptor?
    var currentFrame : Int64 = 0
    var queue : DispatchQueue?
    
    func setupOutput(with settings:Dictionary<String, Any>? = nil, callback: @escaping (Bool)->Void){
        self.queue = DispatchQueue.global(qos: .default)
        if currentFileURL != nil{
            callback(false) //other recording in progress
            return
        }else{
            if let url = settings?["file_url"] as? URL{
                currentFileURL = url
            }else{
                guard let userpath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else{
                    callback(false)
                    return
                }
                let url = URL(fileURLWithPath:userpath).appendingPathComponent(String(format: "dn_%x.mov", time(nil)))
                currentFileURL = url
            }
        }
        
        if currentFileURL != nil{
            fileWriter = try? AVAssetWriter(outputURL: currentFileURL!, fileType: AVFileTypeQuickTimeMovie)
            
            videoInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo, outputSettings: videoOutputSettings)
            videoInput!.expectsMediaDataInRealTime = true
            
            
            self.assetWriterPixelBufferInput = AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: self.videoInput!, sourcePixelBufferAttributes: sourcePixelBufferAttributesDictionary)
            
            if self.fileWriter!.canAdd(videoInput!) {
                self.fileWriter!.add(videoInput!)
            }
            else {
                NSLog("Cannot add asset writer")
            }
            
            self.fileWriter!.startWriting()
            self.fileWriter!.startSession(atSourceTime: kCMTimeZero)
            
            self.currentFrame = 0
            callback(true)
        }else{
            callback(false)
        }
        
    
    }
    func pausedOutput(){
        
    }
    func processBuffer(buffer : CVPixelBuffer){
        //CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
        if !self.videoInput!.isReadyForMoreMediaData {
            return;
        }
        queue?.async { [unowned self] in
            let currentTime:CMTime = self.currentFrame == 0 ? kCMTimeZero : CMTimeMake(self.currentFrame,Int32(self.framePerSec))
            
            if !self.assetWriterPixelBufferInput!.append(buffer, withPresentationTime:currentTime) {
                print("Problem appending pixel buffer at time: \(currentTime.value), status = \(self.fileWriter?.status ?? AVAssetWriterStatus.unknown), error = \(String(describing: (self.fileWriter!.error as? NSError)?.userInfo[NSUnderlyingErrorKey]))")
            }
            //CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags(rawValue: 0))
            self.currentFrame += 1
        }
        
    }
    func completeOutput(callback: @escaping OutputCallback){
        self.videoInput!.markAsFinished()
        self.fileWriter!.finishWriting { [weak self] () -> Void in
            let outputInfo = ["file_url":self?.currentFileURL]
            callback(outputInfo)
            self?.currentFileURL = nil
        }
    }
}
