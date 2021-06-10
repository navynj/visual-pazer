//
//  PageView.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/10.
//

import SwiftUI

struct PageView: View {
    
    @EnvironmentObject var books : BookViewModel
    @EnvironmentObject var navMenu : NavMenuViewModel
    @Binding var gazeNext : Bool
    @Binding var gazePrev : Bool
    
    var body: some View {
        ZStack {
            background
            Image(books.books[0].pages[books.currentIndex])
                .resizable()
                .scaledToFit()
                .overlay(
                    touchArea
                )
                // gaze next
                .overlay(
                    PageCornerView(gazeOn : $gazeNext),
                    alignment: .bottomTrailing
                )
                // gaze prev
                .overlay(
                    PageCornerView(gazeOn : $gazePrev)
                        .rotationEffect(Angle(degrees: 180)),
                    alignment: .topLeading
                )
        }
    }
    
    var background: some View {
        HStack {
            Rectangle()
                .fill(gazePrev ? Color("millieYellow") : Color.gray.opacity(0.2))
            Rectangle()
                .fill(gazeNext ? Color("millieYellow") : Color.gray.opacity(0.2))
        }
    }
    
    var touchArea: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .onTapGesture {
                    books.prevPage()
                    print(books.currentIndex)
                }
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .frame(width: UIScreen.main.bounds.width / 2.5)
                .onTapGesture {
                    navMenu.toggle()
                    print(books.currentIndex)
                }
            Rectangle()
                .fill(Color.white.opacity(0.1))
                .onTapGesture {
                    books.nextPage()
                    print(books.currentIndex)
                }
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(gazeNext: .constant(false), gazePrev: .constant(false))
    }
}
