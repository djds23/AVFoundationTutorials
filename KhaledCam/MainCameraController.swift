//
//  ViewController.swift
//  KhaledCam
//
//  Created by Dean Silfen on 12/24/15.
//  Copyright © 2015 Dean Silfen. All rights reserved.
//

import UIKit
import AVFoundation

class MainCameraController: UIViewController {
    let captureSession = AVCaptureSession()
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    var previewLayer : AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Try switching this to AVCaptureSessionPresetHigh
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        let devices = AVCaptureDevice.devices()
        print(devices)
        for device in devices {
            if (device.hasMediaType(AVMediaTypeVideo)) {
                if (device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        self.beginSession()
                    }
                }
            }
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let firstTouch = Array(touches)[0]
        let touchPercent = firstTouch.locationInView(self.view).x / screenWidth
        self.focusTo(Float(touchPercent))
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let firstTouch = Array(touches)[0]
        let touchPercent = firstTouch.locationInView(self.view).x / screenWidth
        self.focusTo(Float(touchPercent))
    }

    func beginSession() -> Void {
        self.configureDevice()
        
        var captureDeviceInput: AVCaptureDeviceInput?
        do {
            try captureDeviceInput = AVCaptureDeviceInput(device: self.captureDevice)
        } catch (let err) {
            print("could not beginSession")
            print(err)
        }

        self.captureSession.addInput(captureDeviceInput)
        self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
        self.view.layer.addSublayer(previewLayer!)
        self.previewLayer?.frame = self.view.layer.frame
        captureSession.startRunning()
    }
    
    func configureDevice() {
        if let device = self.captureDevice {
            
            do {
                try device.lockForConfiguration()
                
             device.focusMode = .Locked
             device.unlockForConfiguration()
            } catch (let err) {
                print("could not configureDevice")
                print(err)
            }
        }
    }
    
    func focusTo(value: Float) {
        if let device = self.captureDevice {
            
            do {
                try device.lockForConfiguration()
                device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
                    // Do nothing, pass
                })
                print(value)
                device.unlockForConfiguration()
            } catch (let err) {
                print("could not focusTo")
                print(err)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

