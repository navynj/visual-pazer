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
            PageView(gazeNext: $tracker.gazeNext, gazePrev: $tracker.gazePrev, bookIndex: bookIndex)
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
            
            // gaze point
            if tracker.gazePoint.show {
                Circle()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.gray)
                    .position(x: tracker.gazePoint.x, y: tracker.gazePoint.y)
                    .opacity(0.5)
                    .animation(.easeInOut)
            }
            
            // calibration
            if tracker.calibration.start {
                calibrationUI
                    .onDisappear {
                        sideMenu.toggle()
                        navMenu.toggle()
                    }
            }

        }
        .environmentObject(tracker)
    }
    
    var calibrationUI: some View {
        ZStack {
            VStack {
                VStack {
                    Text("시선 추적 설정")
                        .font(.headline)
                    Spacer()
                    VStack(spacing: 0) {
                        Text("화면 중앙의 점을 3~4초간 응시하면")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("자동으로 추적이 완료됩니다.")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 40)
                Button(action: {}, label: {
                    Text("취소하기")
                        .font(.title2)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color("millieYellow"))
                })
            }
            .frame(width: 400, height: 540)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.15), radius: 20, x: 0, y: 20
                )
            )
            .offset(y: 50)
            
            Circle()
                .fill(Color.red)
                .frame(width: 20, height:20)
                .position(tracker.calibration.point)
        }
    }
    
    var showTrackingInfo: some View {
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
                    Text("show : \(tracker.calibration.start.description)")
                            .foregroundColor(.gray)
                }
            )
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
