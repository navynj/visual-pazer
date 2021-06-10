//
//  MainView.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/08.
//

import SwiftUI

struct MainView: View {
    
    @ObservedObject var tracker = TrackerViewModel()
    @ObservedObject var books : BookViewModel = BookViewModel()
    @ObservedObject var sideMenu : SideMenuViewModel = SideMenuViewModel()
    @ObservedObject var navMenu : NavMenuViewModel = NavMenuViewModel()
    @State var bookIndex : Int = 0
    
    var body: some View {
        ZStack {
            // controlloer
            GazeTrackingControllor(tracker: tracker)
            
            // page
//            PageView(gazeNext: $tracker.gazeNext, gazePrev: $tracker.gazePrev)
            PageView(gazeNext: .constant(false), gazePrev: .constant(false))
                .environmentObject(books)
                .environmentObject(navMenu)
            
            // menu
            ZStack {
                NavMenuView(title: books.getBook(bookIndex).title)
                if sideMenu.show {
                    SideMenuView(book: books.getBook(bookIndex))
                }
            }
            .environmentObject(navMenu)
            .environmentObject(sideMenu)
            
            // for test : gaze point
            Circle()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
                .position(x: tracker.gazePoint.x, y: tracker.gazePoint.y)
                .opacity(tracker.gazePoint.show ? 0.5 : 0)
                .animation(.easeInOut)
            
            // for check x, y
            Rectangle()
                .frame(width: 240, height: 200)
                .cornerRadius(20)
                .opacity(0.9)
                .foregroundColor(Color(UIColor.secondarySystemBackground))
                .overlay(
                    VStack {
                        // for test : (x, y) value
                        Text("(x, y) : \(tracker.gazePoint.x), \(tracker.gazePoint.y)")
                            .foregroundColor(.gray)
                    Text("show : \(tracker.gazePoint.show.description)")
                            .foregroundColor(.gray)
                    }
                )
                .onTapGesture {
                    navMenu.toggle()
                }
            
        }
        .environmentObject(tracker)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
