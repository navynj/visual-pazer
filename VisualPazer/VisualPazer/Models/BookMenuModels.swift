//
//  bookMenuModel.swift
//  VisualPazerUI
//
//  Created by 이윤지 on 2021/06/08.
//

import Foundation

struct BookMenuModel: Identifiable {
    let id : String = UUID().uuidString
    let title : String
    let icon : String
}
