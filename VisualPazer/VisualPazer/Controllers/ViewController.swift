//
//  ViewController.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/05.
//


import UIKit
import AVKit
import SeeSo

class ViewController: UIViewController {
    
    var tracker : TrackerViewModel?
    var gazePoint : GazeViewModel?
    var calibration : CalibrationViewModel?
    var status : StatusViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !checkCameraAccess() {
            requestAccess()
        } else {
            status?.curState = .Idle
        }
        initGazeTracker()
    }
    
    private func checkCameraAccess() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    private func requestAccess() {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { response in
            if response {
                self.initGazeTracker()
            }
        })
    }
    
    private func initGazeTracker() {
        GazeTracker.initGazeTracker(license: tracker!.licenseKey, delegate: self)
    }
}


extension ViewController : StatusDelegate {
    func onStarted() {
            print("starts tracking.")
    }
    
    func onStopped(error: StatusError) {
            print("stop error : \(error.description)")
    }
}

extension ViewController : InitializationDelegate {
    func onInitialized(tracker: GazeTracker?, error: InitializationError) {
        if (tracker != nil) {
            self.tracker?.gazeTracker = tracker
            self.tracker?.gazeTracker?.setDelegates(statusDelegate: self, gazeDelegate: self, calibrationDelegate: self, imageDelegate: nil)
            status?.curState = .Initialized
                print("initialized GazeTracker")
        } else {
                print("init failed : \(error.description)")
        }
    }
}

extension ViewController : GazeDelegate {
    func onGaze(gazeInfo: GazeInfo) {
        if self.tracker?.gazeTracker != nil && ((self.tracker?.gazeTracker!.isCalibrating()) != nil) {
            if gazeInfo.trackingState == .SUCCESS {
                if ((self.tracker?.isFiltered) != nil) {
                    gazePoint?.x = CGFloat(gazeInfo.x)
                    gazePoint?.y = CGFloat(gazeInfo.y)
                } else {
                    if self.tracker?.filterManager != nil && self.tracker!.filterManager!.filterValues(timestamp: gazeInfo.timestamp, val: [gazeInfo.x, gazeInfo.y]) {
                        let _xy = self.tracker!.filterManager!.getFilteredValues()
                        gazePoint?.x = CGFloat(_xy[0])
                        gazePoint?.y = CGFloat(_xy[1])
                    }
                }
                gazePoint?.hide = false
            } else {
                gazePoint?.hide = true
            }
        }
    }
}

extension ViewController : CalibrationDelegate {
    func onCalibrationProgress(progress: Double) {
        calibration?.hide = false
        gazePoint?.hide = true
    }
    
    func onCalibrationNextPoint(x: Double, y: Double) {
        status?.curState = .Calibrating
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.calibration?.center = CGPoint(x: CGFloat(x), y: CGFloat(y))
            if let result = self.tracker?.gazeTracker?.startCollectSamples() {
                print("startCollectSamples : \(result)")
            }
        }
    }
    
    func onCalibrationFinished(calibrationData: [Double]) {
        status?.curState = .Tracking
        print("Finished calibration")
        calibration?.hide = true
        gazePoint?.hide = false
    }
}
