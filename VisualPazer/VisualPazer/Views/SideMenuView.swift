//
//  SideMenuView.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/06.
//

import SwiftUI

struct SideMenuView: View {
    
    @State var startTracking: Bool = false
    
    var body: some View {
        ZStack {
            GazeTrackingController()
            VStack {
                    Toggle(isOn: $startTracking, label: {
                        Text("시선 추적 기능")
                    })
                    .toggleStyle(SwitchToggleStyle(tint: Color.yellow))
                    .onChange(of: startTracking, perform: { start in
                        if start {
                            print("start tracking")
                        } else {
                            print("stop tracking")
                        }
                    })

                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Text("초기화")
                            .foregroundColor(.purple)
                    })
            }
            .padding(.horizontal, 420)
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}
