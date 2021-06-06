//
//  TrackerViewModel.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/06.
//

import Foundation
import SeeSo

class TrackerViewModel: ObservableObject {

    @Published var gazeTracker : GazeTracker? = nil
    
    let licenseKey : String = "" // get key here : https://console.seeso.io/#/console/license-keys
    var caliMode : CalibrationMode = .ONE_POINT
    var isFiltered : Bool = true
    var filterManager : OneEuroFilterManager? = OneEuroFilterManager()
    
    func startTracking() {
        gazeTracker?.startTracking()
    }
    
    func stopTracking() {
        gazeTracker?.stopTracking()
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
