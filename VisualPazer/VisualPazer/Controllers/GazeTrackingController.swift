//
//  GazeTrackingController.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/06.
//
import SwiftUI

struct GazeTrackingControllor: UIViewControllerRepresentable {
    
    var tracker : TrackerViewModel
    
    func makeUIViewController(context: Context) -> GazeTrackingViewController {
        let controller = GazeTrackingViewController()
        controller.tracker = tracker
        return controller
    }

    func updateUIViewController(_ uiViewController: GazeTrackingViewController, context: Context) {

    }

}
