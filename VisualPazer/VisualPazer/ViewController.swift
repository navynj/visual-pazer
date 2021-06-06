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
    
    let licenseKey : String = "" // get key here : https://console.seeso.io/#/console/license-keys
    
    var tracker : GazeTracker? = nil
    
    let trackingSwitch : UISwitch = UISwitch()
    let trackingLabel : UILabel = UILabel()
    var gazePointView : GazePointView? = nil
    var isFiltered : Bool = true
    var filterManager : OneEuroFilterManager? = OneEuroFilterManager()
    
    let calibrationBtn : UIButton = UIButton()
    let calibrationLabel : UILabel = UILabel()
    var caliPointView : CalibrationPointView? = nil
    var caliMode : CalibrationMode = .ONE_POINT
    var calibrationData : [Double] = [] // for save data data
    
    enum AppState : String {
        case Disable = "Disable" // User denied access to the camera.
        case Idle = "Idle" // User has allowed access to the camera.
        case Initialized = "Intialized" // GazeTracker has been successfully created.
        case Tracking = "Tracking" // Gaze Tracking state.
        case Calibrating = "Calibrating" // It is being calibrated.
    }
    var curState : AppState? = nil {
        didSet {
            changeState()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if !checkAccessCamera(){
            requestAccess()
        } else {
            self.curState = .Idle
        }
        initViewComponents()
        initGazeTracker()
    }
    
    // Access Camera
    private func requestAccess() {
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
            if response {
                self.curState = .Idle
            } else {
                self.curState = .Disable // If you are denied access, you cannot use any funcion
            }
        }
    }

    private func checkAccessCamera() -> Bool {
        return AVCaptureDevice.authorizationStatus(for: .video) == .authorized
    }
    
    // State : whenever the AppState, UI processing and appropriate functions are called.
    private func changeState() {
        if let state : AppState = curState {
            print("state : \(state.rawValue)")
            DispatchQueue.main.async {
                switch state {
                case .Disable:
                    self.disableUI()
                case .Idle:
                    self.setIdleUI()
                case .Initialized:
                    self.setInitUI()
                case .Tracking:
                    self.setTrackingUI()
                case .Calibrating:
                    self.setCalibratingUI()
                }
            }
        }
    }
    
    // Idle
    private func initGazeTracker() {
        GazeTracker.initGazeTracker(license: licenseKey, delegate: self)
    }
    
    // Tracking
    private func startTracking() {
        tracker?.startTracking()
    }
    
    private func stopTracking() {
        tracker?.stopTracking()
    }
    
    // Calibrating
    private func startCalibration() {
        print("Start Calibration : \(caliMode)")
        let result = tracker?.startCalibration(mode : caliMode)
        if let isStart = result {
            if !isStart {
                print("Calibration Started faild.")
            }
        }
    }
    
    // UI control
    @objc func onClickSwitch(sender : UISwitch) {
        sender.isEnabled = false
        if sender == trackingSwitch {
            if sender.isOn {
                startTracking()
            } else {
                stopTracking()
            }
        }
    }
    
    @objc func onClickBtn(sender : UIButton) {
        if sender == calibrationBtn {
            startCalibration()
            // if curState == AppState.Tracking {
            //     curState = .Calibrating
            //     self.calibrationBtn.setTitle("STOP", for: .normal)
            // }
            // if curState == AppState.Calibrating { stopCalibration() // setTitle("START", for .normal) }
        }
    }

}

// Delegate : init
extension ViewController : InitializationDelegate {
    func onInitialized(tracker: GazeTracker?, error: InitializationError) {
        if tracker != nil {
            self.tracker = tracker
            self.tracker?.setDelegates(statusDelegate: self, gazeDelegate: self, calibrationDelegate: self, imageDelegate: nil)
            curState = .Initialized
        } else {
            print(error.description)
        }
    }
}

// Delegate : status
extension ViewController : StatusDelegate {
    func onStarted() {
         curState = .Tracking
    }
    
    func onStopped(error: StatusError) {
         curState = .Initialized
    }
}

// Delegate : gaze - set more UI according to gazeInfo (x, y)
extension ViewController : GazeDelegate {
    func onGaze(gazeInfo: GazeInfo) {
        
        // During the calibration process, the gaze UI is not displayed.
        if tracker != nil && tracker!.isCalibrating() {
            self.hidePointView(view: self.gazePointView!)
        } else {
            if !self.isFiltered {
                // No filter : the x, y coordinates ar used directly to show the gaze coordinates
                if gazeInfo.trackingState == .SUCCESS {
                    self.showPointView(view: self.gazePointView!)
                    self.gazePointView?.moveView(x: gazeInfo.x, y: gazeInfo.y)
                } else {
                    self.hidePointView(view: self.gazePointView!)
                }
            } else {
                // Filter in use : using filtered value throught the filter manager
                if gazeInfo.trackingState == .SUCCESS {
                    if filterManager != nil && filterManager!.filterValues(timestamp: gazeInfo.timestamp, val: [gazeInfo.x, gazeInfo.y]) {
                        let _xy = filterManager!.getFilteredValues()
                        self.showPointView(view: self.gazePointView!)
                        self.gazePointView?.moveView(x: _xy[0], y: _xy[1])
                    }
                } else {
                    self.hidePointView(view: self.gazePointView!)
                }
            }
        }
    }
}

// Delegate : calibration
extension ViewController : CalibrationDelegate {
    func onCalibrationProgress(progress: Double) {
        // Activated calibration UI
        caliPointView?.setProgress(progress: progress)
        showPointView(view: caliPointView!)
        hidePointView(view: gazePointView!)
    }
    
    func onCalibrationNextPoint(x: Double, y: Double) {
        // Do calibration UI
        curState = .Calibrating
        DispatchQueue.main.async {
            self.caliPointView?.center = CGPoint(x: CGFloat(x), y: CGFloat(y))
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                if let result = self.tracker?.startCollectSamples(){
                    print("startCollectSamples : \(result)")
                }
            })
        }
    }
    
    func onCalibrationFinished(calibrationData: [Double]) {
        // Deactivate calibration UI
        curState = .Tracking
        print("Finished calibration")
        showPointView(view: gazePointView!)
        hidePointView(view: caliPointView!)
        self.calibrationData = calibrationData // for save data
    }
}

// UI : pointViews
extension ViewController {
    
    // init components
    private func initViewComponents() {
        initTrackingUI()
        initCalibrationUI()
        initGazePointView()
        initCalibrationPointView()
    }
    
    private func disableUI() {
        disableSwitch(select: trackingSwitch)
        disableBtn(select: calibrationBtn)
    }
    
    private func setIdleUI() {
        resetSwitch(select: trackingSwitch)
        disableSwitch(select: trackingSwitch)
        disableBtn(select: calibrationBtn)
        hidePointView(view: gazePointView!)
        hidePointView(view: caliPointView!)
    }
    
    private func setInitUI() {
        enableSwitch(select: trackingSwitch)
        disableBtn(select: calibrationBtn)
        hidePointView(view: gazePointView!)
        hidePointView(view: caliPointView!)
    }
    
    private func setTrackingUI() {
        hidePointView(view: caliPointView!)
        showPointView(view: gazePointView!)
        enableSwitch(select: trackingSwitch)
        enableBtn(select: calibrationBtn)
    }
    
    private func setCalibratingUI() {
        hidePointView(view: gazePointView!)
        showPointView(view: caliPointView!)
        // set more calibrating UI (e.g. modal)
    }
    
    // init button & switch
    private func initTrackingUI() {
        // switch
        trackingSwitch.frame.size = CGSize(width: 50, height: 50)
        trackingSwitch.frame.origin = CGPoint(x: self.view.frame.width - 120, y: self.view.frame.height/2 - 20)
        trackingSwitch.addTarget(self, action: #selector(onClickSwitch(sender:)), for: .valueChanged)
        self.view.addSubview(trackingSwitch)
        
        // label
        trackingLabel.frame.size = CGSize(width: 150, height: trackingSwitch.frame.height)
        trackingLabel.frame.origin = CGPoint(x: trackingSwitch.frame.minX - (trackingSwitch.frame.width + 100),
                                             y: trackingSwitch.frame.minY)
        trackingLabel.text = "시선 추적 기능"
        trackingLabel.textAlignment = .left
        self.view.addSubview(trackingLabel)
    }
    
    private func initCalibrationUI() {
        // button
        calibrationBtn.frame.size = CGSize(width: 50, height: 50)
        calibrationBtn.frame.origin = CGPoint(x: self.view.frame.width - 120, y: self.view.frame.height/2 + 20)
        calibrationBtn.addTarget(self, action: #selector(onClickBtn(sender:)), for: .touchUpInside)
        calibrationBtn.setTitle("START", for: .normal)
        calibrationBtn.setTitleColor(.gray, for: .disabled)
        calibrationBtn.setTitleColor(.black, for: .normal)
        calibrationBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        self.view.addSubview(calibrationBtn)
        
        // label
        calibrationLabel.frame.size = CGSize(width: 150, height: calibrationBtn.frame.height)
        calibrationLabel.frame.origin = CGPoint(x: calibrationBtn.frame.minX - (calibrationBtn.frame.width + 100),
                                                y: calibrationBtn.frame.minY)
        calibrationLabel.text = "초기화"
        calibrationLabel.textAlignment = .left
        self.view.addSubview(calibrationLabel)
    }
    
    // init points
    private func initGazePointView() {
        self.gazePointView = GazePointView(frame: self.view.bounds)
        self.view.addSubview(gazePointView!)
        hidePointView(view: gazePointView!)
    }
    
    private func initCalibrationPointView() {
        self.caliPointView = CalibrationPointView(frame: CGRect(origin: .zero, size: CGSize(width: 40, height: 40)))
        self.view.addSubview(caliPointView!)
        hidePointView(view: caliPointView!)
    }
    
    // control points
    private func hidePointView(view : UIView) {
        DispatchQueue.main.async {
            if !view.isHidden {
                view.isHidden = true
            }
        }
    }
    
    private func showPointView(view : UIView) {
        DispatchQueue.main.async {
            if view.isHidden {
                // show pointView
                view.isHidden = false
                // show caliPointView
                if view == self.caliPointView {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        if let result = self.tracker?.startCollectSamples() {
                            print("startCollectSample : \(result)")
                        }
                    })
                }
            }
        }
    }
    
    // control switch & btn
    private func resetSwitch(select : UISwitch) {
        DispatchQueue.main.async {
            select.setOn(false, animated: true)
        }
    }
    
    private func disableSwitch(select : UISwitch) {
        DispatchQueue.main.async {
            select.isEnabled = false
        }
    }
    
    private func enableSwitch(select : UISwitch) {
        DispatchQueue.main.async {
            select.isEnabled = true
        }
    }
    
    private func disableBtn(select : UIButton) {
        DispatchQueue.main.async {
            select.isEnabled = false
        }
    }
    
    private func enableBtn(select : UIButton) {
        DispatchQueue.main.async {
            select.isEnabled = true
        }
    }

}
