//
//  SideMenuView.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/06.
//

import SwiftUI

struct SideMenuView: View {
    
    @EnvironmentObject var sideMenu : SideMenuViewModel
    
    let book : BookModel
    let sideMenuWidth : CGFloat = UIScreen.main.bounds.width * 0.44
    
    var body: some View {
            HStack {
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        sideMenu.toggle()
                    }
                Rectangle()
                    .fill(Color(UIColor.secondarySystemBackground))
                    .frame(width: sideMenuWidth, alignment: .trailing)
                    .shadow(color: .gray.opacity(0.2), radius: 50, x: -30, y: 0)
                    .ignoresSafeArea()
                    .overlay(
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                BookInfoView(
                                    cover: book.cover,
                                    title: book.title,
                                    author: book.author
                                )
                                TrackerSettingView()
                                ViewerSettingView()
                        }
                    },
                     alignment: .top
                 )
            }
            .transition(.move(edge: .trailing))
            .animation(.easeInOut)
            .zIndex(1)
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        let bookModel : BookModel = BookModel(
           cover: "test",
           title: "공간의 미래",
           author: "유현준 (지은이)"
       )
        SideMenuView(book: bookModel)
//        .previewDevice("iPhone 12")
    }
}
