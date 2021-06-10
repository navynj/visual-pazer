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
        BookModel(cover : "literature", title : "달러구트 꿈 백화점", author : "이미예", pages : ["literature_1", "literature_2", "literature_3"]),
        BookModel(cover : "non_literary", title : "읽으면 진짜 주식으로 돈 버는 법", author : "조혁진 (지은이)", pages : ["non_literary_1", "non_literary_2", "non_literary_3"]),
        BookModel(cover : "poetry", title : "심훈 시집", author : "심훈 ", pages: ["poetry_1", "poetry_2", "poetry_3"])
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
