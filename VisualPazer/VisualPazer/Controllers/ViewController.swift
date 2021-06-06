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
    
    var curState : AppState? = nil
    var showGazePoint : Bool = false
    var showCaliPoint : Bool = false
    var xy = [Double](repeating: 0, count: 2)
    
    enum AppState : String {
        case Disable = "Disable"
        case Idle = "Idle"
        case Initialized = "Initialized"
        case Tracking = "Tracking"
        case Calibrating = "Calibradting"
    }
    
    private let licenseKey : String = "" // get key here : https://console.seeso.io/#/console/license-keys
    private var tracker : GazeTracker? = nil
    
    private var isFiltered : Bool = true
    private var filterManager : OneEuroFilterManager? = OneEuroFilterManager()
    private var caliMode : CalibrationMode = .ONE_POINT

    override func viewDidLoad() {
        super.viewDidLoad()
        if !checkCameraAccess() {
            requestAccess()
        } else {
            self.curState = .Idle
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
        GazeTracker.initGazeTracker(license: self.licenseKey, delegate: self)
    }
    
    func startTracking() {
        tracker?.startTracking()
    }
    
    func stopTracking() {
        tracker?.stopTracking()
    }
    
    func startCalibration() {
        let result = tracker?.startCalibration(mode : caliMode)
        if let isStart = result {
            if !isStart {
                print("Calibration Started failed.")
            }
        }
    }
}


extension ViewController : StatusDelegate {
    func onStarted() {
            print("tracker starts tracking.")
    }
    
    func onStopped(error: StatusError) {
            print("stop error : \(error.description)")
    }
}

extension ViewController : InitializationDelegate {
    func onInitialized(tracker: GazeTracker?, error: InitializationError) {
        if (tracker != nil) {
            self.tracker = tracker
            self.tracker?.setDelegates(statusDelegate: self, gazeDelegate: self, calibrationDelegate: self, imageDelegate: nil)
            curState = .Initialized
            startTracking() // for test
                print("initialized GazeTracker")
        } else {
                print("init failed : \(error.description)")
        }
    }
}

extension ViewController : GazeDelegate {
    func onGaze(gazeInfo: GazeInfo) {
        if tracker != nil && !tracker!.isCalibrating() {
            if gazeInfo.trackingState == .SUCCESS {
                if !self.isFiltered {
                        xy = [gazeInfo.x, gazeInfo.y]
                } else {
                    if filterManager != nil && filterManager!.filterValues(timestamp: gazeInfo.timestamp, val: [gazeInfo.x, gazeInfo.y]) {
                        xy = filterManager!.getFilteredValues()
                    }
                }
//                print("timestamp : \(self.gaze.timestamp)")
                print("x, y : \(self.xy[0]), \(self.xy[1])")
//                print("state : \(self.gaze.trackingState)")
            } else {
                self.showGazePoint = false
            }
        }
    }
}

extension ViewController : CalibrationDelegate {
    func onCalibrationProgress(progress: Double) {
        showCaliPoint = true
        showGazePoint = false
    }
    
    func onCalibrationNextPoint(x: Double, y: Double) {
        curState = .Calibrating
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            // self.caliPointView?.center = CGPoint(x: CGFloat(x), y: CGFloat(y)) // - 화면에 어떻게 할지 생각해보기
            if let result = self.tracker?.startCollectSamples() {
                print("startCollectSamples : \(result)")
            }
        }
    }
    
    func onCalibrationFinished(calibrationData: [Double]) {
        curState = .Tracking
        print("Finished calibration")
        showCaliPoint = false
        showGazePoint = true
    }
}
