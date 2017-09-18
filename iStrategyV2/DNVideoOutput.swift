//
//  DNVideoOutput.swift
//  iStrategyV2
//
//  Created by Dang Ninh on 22/8/17.
//  Copyright © 2017 Ha Dang Ninh. All rights reserved.
//

import Foundation
import AVFoundation

protocol DNVideoOutput {
    func setupOutput(with settings:Dictionary<String, Any>?, callback: @escaping (Bool)->Void)
    func pausedOutput()
    func processBuffer(buffer : CVPixelBuffer)
    func completeOutput(callback: @escaping OutputCallback)
}
