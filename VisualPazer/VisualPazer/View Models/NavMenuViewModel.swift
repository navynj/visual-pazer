//
//  NavMenuViewModel.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/09.
//

import Foundation

class NavMenuViewModel: ObservableObject {
    @Published var show: Bool = false
    
    func toggle() {
        if show {
            show = false
        } else {
            show = true
        }
    }
}
