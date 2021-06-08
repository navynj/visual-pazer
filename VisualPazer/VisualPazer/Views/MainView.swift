//
//  MainView.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/08.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var tracker = TrackerViewModel()
    @ObservedObject var sideMenu : SideMenuViewModel = SideMenuViewModel()
    @ObservedObject var navMenu : NavMenuViewModel = NavMenuViewModel()
    
    let bookModel : BookModel = BookModel(
       cover: "test",
       title: "공간의 미래",
       author: "유현준 (지은이)"
   )
    
    var body: some View {
        ZStack {
            // controlloer
            GazeTrackingControllor(tracker: tracker)
            
            // background
            Rectangle()
                .foregroundColor(Color(UIColor.secondarySystemBackground))
                .overlay(
                    VStack {
                        // for test : (x, y) value
                        Text("(x, y) : \(tracker.gazePoint.x), \(tracker.gazePoint.y)")
                            .foregroundColor(.gray)
                        Text("hide : \(tracker.gazePoint.show.description)")
                            .foregroundColor(.gray)
                    }
                )
                .onTapGesture {
                    navMenu.toggle()
                }
            
            // for test : gaze point
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
                .position(x: tracker.gazePoint.x, y: tracker.gazePoint.y)
                .opacity(tracker.gazePoint.show ? 0.5 : 0)
                .animation(.easeInOut)
            
            
            // menu
            ZStack {
                NavMenuView()
                if sideMenu.show {
                    SideMenuView(book: bookModel)
                }
            }
            .environmentObject(sideMenu)
            .environmentObject(navMenu)
        }
        .environmentObject(tracker)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
