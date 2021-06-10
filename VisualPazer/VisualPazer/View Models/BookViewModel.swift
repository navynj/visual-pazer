//
//  BookViewModel.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/10.
//

import Foundation
class BookViewModel: ObservableObject {
    
    // book info
    @Published var books : [BookModel] = [
        BookModel(cover : "literature", title : "달러구트 꿈 백화점", author : "이미예", pages : ["literature_1", "literature_2", "literature_3", "literature_4", "literature_5", "literature_6", "literature_7"]),
        BookModel(cover : "nonliterary", title : "읽으면 진짜 주식으로 돈 버는 법", author : "조혁진 (지은이)", pages : ["nonliterary_1", "nonliterary_2", "nonliterary_3", "nonliterary_4", "nonliterary_5", "nonliterary_6", "nonliterary_7"]),
        BookModel(cover : "poetry", title : "심훈 시집", author : "심훈 ", pages: ["poetry_1", "poetry_2", "poetry_3", "poetry_4", "poetry_5", "poetry_6", "poetry_7"])
    ]
    
    @Published var currentIndex : Int = 0
    
    func getBook(_ index : Int) -> BookModel {
        return books[index]
    }
    
    func nextPage() {
        if self.currentIndex < self.books[0].pages.count - 1 {
            self.currentIndex += 1
        }
    }
    
    func prevPage() {
        if self.currentIndex > 0 {
            self.currentIndex -= 1
        }
    }
}
