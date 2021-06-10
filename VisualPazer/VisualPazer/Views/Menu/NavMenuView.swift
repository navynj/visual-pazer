//
//  NavMenuView.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/08.
//

import SwiftUI

struct NavMenuView: View {
    
    @EnvironmentObject var navMenu : NavMenuViewModel
    @EnvironmentObject var sideMenu : SideMenuViewModel
    
    @State var currentPage : Double = 32.0
    @State var pageLength : Double = 100.0
    
    var sideMenuWidth : CGFloat = UIScreen.main.bounds.width * 0.44
    var title : String
    
    var body: some View {
        // Navigator View
        VStack() {
            // top nav
            Rectangle()
                .frame(height: UIScreen.main.bounds.height * 0.06)
                .foregroundColor(.white).opacity(0.9)
                .overlay(
                    topNav
                        .padding(.horizontal, 20)
                )
            Spacer(minLength: 120)
            // bottom nav
            Rectangle()
                .frame(height: UIScreen.main.bounds.height * 0.08)
                .foregroundColor(.white).opacity(0.9)
                .overlay(
                    bottomNav
                        .padding(.horizontal, 40)
                )
        }
        .opacity(navMenu.show ? 1 : 0)
        .animation(.easeInOut)
        }
    
    var topNav: some View {
        HStack() {
            Button(action: {}, label: {
                Image(systemName: "chevron.left")
                    .foregroundColor(.primary)
            })
            Spacer()
            Text(title)
            Button(action: {}, label: {
                Image(systemName: "chevron.down.circle.fill")
                    .resizable()
                    .foregroundColor(.primary)
                    .frame(width: 14, height: 14)
            })
            Spacer()
            Button(action: {}, label: {
                Image(systemName: "bookmark")
                    .foregroundColor(.primary)
            })
        }
    }
    
    var bottomNav: some View {
        VStack(alignment: .leading, spacing: 8) {
            Slider(value: $currentPage, in: 0...pageLength, step: 1.0)
                .accentColor(.gray)
            HStack() {
                Button(action: {}, label: {
                    Image(systemName: "play.fill")
                        .resizable()
                        .frame(width: 12, height: 12)
                        .padding(8)
                        .foregroundColor(.primary)
                })
                Spacer()
                Text(String(format: "%.0f", currentPage))
                Text(String(format: "/  %.0f", pageLength))
                    .foregroundColor(.gray)
                Spacer()
                Button(action: {
                    sideMenu.toggle()
                },
                label: {
                    Image(systemName: "line.horizontal.3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.primary)
                })
            }
        }
    }
}

struct NavMenuView_Previews: PreviewProvider {
    static var previews: some View {
        NavMenuView(title: "달러구트 꿈 백화점")
            .background(Color(UIColor.secondarySystemBackground))
    }
}
