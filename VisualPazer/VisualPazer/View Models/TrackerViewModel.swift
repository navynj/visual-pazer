//
//  TrackerViewModel.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/06.
//
import Foundation
import SeeSo

class TrackerViewModel: ObservableObject {

    @Published var isTracking : Bool = false
    @Published var gazePoint : GazeModel = GazeModel()
    @Published var caliPoint : CalibrationModel = CalibrationModel()
    @Published var gazeNext : Bool = false
    @Published var gazePrev : Bool = false
    
    var gazeTracker : GazeTracker? = nil

    let licenseKey : String = License().key // get key here : https://console.seeso.io/#/console/license-keys
    var caliMode : CalibrationMode = .ONE_POINT
    var isFiltered : Bool = false
    var filterManager : OneEuroFilterManager? = OneEuroFilterManager()

    func startTracking() {
        gazeTracker?.startTracking()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.toggleGazePoint()
        })
    }

    func stopTracking() {
        gazeTracker?.stopTracking()
        gazePoint.show = true
    }
    
    func toggleGazePoint() {
        if gazePoint.show {
            gazePoint.show = false
        } else {
            gazePoint.show = true
        }
    }

    func startCalibration() {
        let result = gazeTracker?.startCalibration(mode : caliMode)
        if let isStart = result {
            if !isStart {
                print("Calibration Started faild.")
            }
        }
    }

}
