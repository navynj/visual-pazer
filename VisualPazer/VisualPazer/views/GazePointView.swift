//
//  GazePointView.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/05.
//

import UIKit
import Foundation

class GazePointView : UIView {
    
    let pointView : UIView = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubview()
        isUserInteractionEnabled = false
    }
    
    private func initSubview() {
        pointView.frame.size = CGSize(width: 24, height: 24)
        pointView.layer.cornerRadius = pointView.frame.width/2
        pointView.backgroundColor = .gray
        self.addSubview(pointView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveView(x: Double, y: Double) {
        let centerPoint = CGPoint(x: x, y: y)
        DispatchQueue.main.async {
            self.pointView.center = centerPoint
        }
    }
}
