//
//  BookModel.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/08.
//

import Foundation

struct BookModel: Identifiable {
    let id : String = UUID().uuidString
    let cover : String
    let title : String
    let author : String
    let pages : [String] = []
}
