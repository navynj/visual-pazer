//
//  PageCornerView.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/10.
//

import SwiftUI

struct PageTurnerView: View {
    @Binding var gazeOn : Bool
    
    var body: some View {
        ZStack {
            PageCurl()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [.white, Color(#colorLiteral(red: 0.8992545009, green: 0.8939090371, blue: 0.9033635259, alpha: 1))]),
                        center: .topLeading,
                        startRadius: 5,
                        endRadius: 1000
                    )
                )
                .frame(width: gazeOn ? 50 : 40, height: gazeOn ? 50 : 40)
                .shadow(color: .gray.opacity(0.3), radius: 10, x: -10, y: -5)
            PageCorner()
                .fill(gazeOn ? Color("millieYellow") : Color.gray.opacity(0.2))
                .overlay(
                    Image(systemName: "arrow.right")
                        .font(gazeOn ? .title3 : .subheadline)
                        .foregroundColor(gazeOn ? .black.opacity(0.7) : .black.opacity(0.4))
                        .frame(width: 20, height: 30),
                    alignment: .bottomTrailing
                )
                .frame(width: gazeOn ? 50 : 40, height: gazeOn ? 50 : 40)
        }
        .frame(maxWidth: UIScreen.main.bounds.width / 2,
               alignment: .bottomTrailing)
    }
}

struct PageCurl: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct PageCorner: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        
        return path
    }
}

struct PageTurnerView_Previews: PreviewProvider {
    static var previews: some View {
        PageTurnerView(gazeOn: .constant(false))
    }
}
