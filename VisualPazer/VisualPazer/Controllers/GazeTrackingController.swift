//
//  ViewController.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/06.
//

import SwiftUI

struct GazeTrackingController: UIViewControllerRepresentable {
    
    var tracker : TrackerViewModel
    var gazePoint : GazeViewModel
    var calibration : CalibrationViewModel
    var status : StatusViewModel
    
    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        viewController.tracker = tracker
        viewController.gazePoint = gazePoint
        viewController.calibration = calibration
        viewController.status = status
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {

    }

}
