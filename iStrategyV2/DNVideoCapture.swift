//
//  DNVideoCapture.swift
//  iStrategyV2
//
//  Created by Dang Ninh on 22/8/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import Foundation
import UIKit
class DNVideoCapture{
    static let framePerSec = 15
    var isRecording = false
    var queue : DispatchQueue?
    var source : DispatchSourceTimer?
    let sourceView : UIView?
    let output : DNVideoOutput = DNVideoFileOutput()
    init(view:UIView){
        sourceView=view
    }
    func startRecording(){
        if isRecording{
            return
        }
        output.setupOutput(with: [:]){[weak self](success) in
            if success{
                self?.startCapturing()
            }
            self?.isRecording = success
        }
    }
    
    fileprivate func startCapturing(){
        let process_queue = DispatchQueue.global(qos: .default)
        
        self.queue = DispatchQueue.global(qos: .default)
        self.source = DispatchSource.makeTimerSource(queue: self.queue)
        
        
        source?.scheduleRepeating(deadline: .now(), interval: .milliseconds(1000/DNVideoCapture.framePerSec))
        source?.setEventHandler { [weak self] in
            DispatchQueue.main.async {
                if let buffer = self?.sourceView?.layerToImage()?.toBuffer(){
                    process_queue.async {
                        self?.output.processBuffer(buffer: buffer)
                    }
                }
            }
        }
        
        source?.resume()
    }
    func stop(){
        self.output.completeOutput{ [weak self](outputInfo) in
            self?.source?.cancel()
            self?.isRecording = false
        }
    }
}
extension UIImage{
    func toBuffer()->CVPixelBuffer?{
        let cgImage = self.cgImage!
        let options : [String:Any] = [kCVPixelBufferCGImageCompatibilityKey as String:true,
                                      kCVPixelBufferCGBitmapContextCompatibilityKey as String:true]
        
        var buffer : CVPixelBuffer? = nil
        CVPixelBufferCreate(kCFAllocatorDefault, cgImage.width, cgImage.height, kCVPixelFormatType_32ARGB, options as CFDictionary, &buffer)
        if buffer == nil{
            return nil
        }
        CVPixelBufferLockBaseAddress(buffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        let data = CVPixelBufferGetBaseAddress(buffer!)
        let colorSpace  = CGColorSpaceCreateDeviceRGB()
        let context        = CGContext(data: data, width: cgImage.width, height: cgImage.height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(buffer!), space: colorSpace,  bitmapInfo: CGBitmapInfo(rawValue:( CGBitmapInfo.alphaInfoMask.rawValue & CGImageAlphaInfo.noneSkipFirst.rawValue)).rawValue)
        
        context?.draw(cgImage, in: CGRect(x:0.0,y: 0.0, width: CGFloat(cgImage.width),height: CGFloat(cgImage.height)))
        
        
        CVPixelBufferUnlockBaseAddress(buffer!, CVPixelBufferLockFlags(rawValue: 0));
        
        return buffer;
    }
}
extension UIView{
    /**
      Snapshot the UIView to a UIImage.
     
     - Remark:
     This method is faster than the toImage() function. But the GLlayer is not captured
     
     */
    func layerToImage()->UIImage?{
        UIGraphicsBeginImageContext(CGSize(width:720,height:480))
        if let context = UIGraphicsGetCurrentContext(){
            context.scaleBy(x: 720/self.bounds.size.width, y: 480/self.bounds.size.height);
            
            self.layer.presentation()?.render(in: context)
            
            let snapshotImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return snapshotImage;
        }
        UIGraphicsEndImageContext()
        return nil
    }
    func toImage()->UIImage?{
        UIGraphicsBeginImageContextWithOptions(CGSize(width:720,height:480) , true , 0 );
        self.drawHierarchy(in: CGRect(x:0,y:0,width:720,height:480), afterScreenUpdates: false)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext();
        return image
    }
}
