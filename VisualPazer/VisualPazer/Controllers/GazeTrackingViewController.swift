//
//  GazeTrackingViewController.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/05.
//

import UIKit
import AVKit
import SeeSo

class GazeTrackingViewController: UIViewController {
    
    var tracker : TrackerViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !checkCameraAccess() {
            requestAccess()
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


extension GazeTrackingViewController : StatusDelegate {
    func onStarted() {
        tracker?.isTracking = true
        tracker?.gazePoint.show = true
            print("starts tracking.")
    }
    
    func onStopped(error: StatusError) {
        tracker?.isTracking = false
        tracker?.gazePoint.show = false
            print("stop error : \(error.description)")
    }
}

extension GazeTrackingViewController : InitializationDelegate {
    func onInitialized(tracker: GazeTracker?, error: InitializationError) {
        if (tracker != nil) {
            self.tracker?.gazeTracker = tracker
            self.tracker?.gazeTracker?.setDelegates(statusDelegate: self, gazeDelegate: self, calibrationDelegate: self, imageDelegate: nil)
                print("initialized GazeTracker")
        } else {
                print("init failed : \(error.description)")
        }
    }
}

extension GazeTrackingViewController : GazeDelegate {
    func onGaze(gazeInfo: GazeInfo) {
        if self.tracker?.gazeTracker != nil && ((self.tracker?.gazeTracker!.isCalibrating()) != nil) {
            if gazeInfo.trackingState == .SUCCESS {
                if ((self.tracker?.isFiltered) != nil) {
                    tracker?.gazePoint.x = CGFloat(gazeInfo.x)
                    tracker?.gazePoint.y = CGFloat(gazeInfo.y)
                } else {
                    if self.tracker?.filterManager != nil && self.tracker!.filterManager!.filterValues(timestamp: gazeInfo.timestamp, val: [gazeInfo.x, gazeInfo.y]) {
                        let _xy = self.tracker!.filterManager!.getFilteredValues()
                        tracker?.gazePoint.x = CGFloat(_xy[0])
                        tracker?.gazePoint.y = CGFloat(_xy[1])
                    }
                }
            }
        }
    }
}

extension GazeTrackingViewController : CalibrationDelegate {
    func onCalibrationProgress(progress: Double) {
        tracker?.caliPoint.show = true
        tracker?.gazePoint.show = false
    }
    
    func onCalibrationNextPoint(x: Double, y: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.tracker?.caliPoint.center = CGPoint(x: CGFloat(x), y: CGFloat(y))
            if let result = self.tracker?.gazeTracker?.startCollectSamples() {
                print("startCollectSamples : \(result)")
            }
        }
    }
    
    func onCalibrationFinished(calibrationData: [Double]) {
        print("Finished calibration")
        tracker?.caliPoint.show = false
        tracker?.gazePoint.show = true
    }
}
