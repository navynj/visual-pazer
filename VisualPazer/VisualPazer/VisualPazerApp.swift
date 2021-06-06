//
//  VisualPazerApp.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/06.
//

import SwiftUI

@main
struct VisualPazerApp: App {
    
//    @StateObject var gazePoint: GazeViewModel = GazeViewModel()
//    @StateObject let tracker: TrackerViewModel = TrackerViewModel()
    
    var body: some Scene {
        WindowGroup {
            TestView()
//                .environmentObject(gazePoint)
//                .environmentObject(tracker)
        }
    }
}
