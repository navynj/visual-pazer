//
//  PageTurningView.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/10.
//

import SwiftUI

struct PageTurningView: View {
    
    @EnvironmentObject var tracker : TrackerViewModel
    @EnvironmentObject var books : BookViewModel
    @Binding var onGaze : Bool
    @State var fillColor : Bool = false
    
    var alignment : Alignment
    let pageTurn : () -> ()
    let duration : Double = 1.0
    
    var body: some View {
        HStack {
            ZStack(alignment: alignment) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                if onGaze && !tracker.calibration.start {
                    Rectangle()
                        .fill(Color("millieYellow"))
                        .frame(maxHeight: fillColor ? .infinity : 0)
                        .onAppear {
                            withAnimation(Animation.timingCurve(0.6, 0.4, 0.8, 0.35, duration: duration)) {
                                self.fillColor = true
                            }
                            Timer.scheduledTimer(withTimeInterval: duration, repeats: false) { timer in
                                if onGaze {
                                    pageTurn()
                                }
                                timer.invalidate()
                            }
                        }
                        .onDisappear {
                            self.fillColor = false
                        }
                    }
                }
            }
        }
}
//
//struct PageTurningView_Previews: PreviewProvider {
//    static var previews: some View {
//        PageTurningView(onGaze: .constant(true), alignment: .topLeading, pageTurn: DispatchWorkItem(block: {print("page turning..")}))
//    }
//}
