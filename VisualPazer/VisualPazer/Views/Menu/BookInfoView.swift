//
//  BookInfoView.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/08.
//

import SwiftUI

struct BookInfoView: View {
    
    let cover : String
    let title : String
    let author : String
    let bookMenuList : [BookMenuModel] = [
        BookMenuModel(title: "이 책의 한 줄 리뷰", icon: "text.bubble"),
        BookMenuModel(title: "하이라이트 · 메모", icon: "text.quote"),
        BookMenuModel(title: "북마크", icon: "bookmark"),
        BookMenuModel(title: "뷰어 · 도서 오류 제보", icon: "paperplane")
    ]

    var body : some View {
        searchBox
        bookInfo
        bookMenu
    }

    var searchBox : some View {
        Capsule()
            .frame(height: 40)
            .foregroundColor(.white)
            .overlay(
                ZStack(alignment: .leading) {
                    Capsule()
                        .stroke(Color.gray.opacity(0.5), lineWidth: 0.5)
                    Label("본문 검색", systemImage: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.horizontal)
                },
                alignment: .leading
            )
            .padding(.horizontal, 10)
    }
    
    var bookInfo : some View {
        HStack(alignment: .bottom) {
            Image(cover)
                .resizable()
                .frame(width: 80, height: 110)
                .cornerRadius(4)
                .shadow(color: .gray.opacity(0.3), radius: 8, x: 2, y: 2)
                .scaledToFill()
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                Text(author)
                    .font(.subheadline)
            }
        }
        .padding(.horizontal, 10)
    }
    
    var bookMenu : some View {
        VStack {
            ForEach(bookMenuList) { menu in
                HStack (alignment: .center) {
                    Label(menu.title, systemImage: menu.icon)
                        .accentColor(.primary)
                        .font(.headline)
                        .padding(10)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                Divider()
            }
        }
        .padding(.horizontal)
        .background(Color.white)
    }
}

struct BookInfoView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 20) {
            BookInfoView(cover:"test", title:"공간의 미래", author:"유현준 (지은이)")
        }
        .frame(width: UIScreen.main.bounds.width * 0.44)
        .previewLayout(.sizeThatFits)
    }
}
