//
//  TrackerSettingView.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/08.
//

import SwiftUI

struct TrackerSettingView : View {
    
    @EnvironmentObject var tracker : TrackerViewModel
    
    var body : some View {
        VStack (alignment: .leading) {
            // Title
            Text("시선 추적 기능")
                .font(.headline)
            // Tracker
            Toggle(isOn: $tracker.isTracking) {
                VStack(alignment: .leading) {
                    Text("시작하기")
                        .font(.subheadline)
                    Text("눈동자의 움직임을 추적하여 페이지를 넘깁니다.")
                        .font(.caption)
                        .foregroundColor(.black.opacity(0.5))
                }
            }
            .padding()
            .padding(.horizontal, 5)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("millieYellow"))
            )
            .toggleStyle(SwitchToggleStyle(tint: Color.black.opacity(0.8)))
            .onChange(of: tracker.isTracking, perform: { start in
                if start {
                    tracker.startTracking()
                } else {
                    tracker.stopTracking()
                }
            })
            
            // Calibration
            HStack {
                
                Text("시선 포인트 활성화")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
                    .foregroundColor(Color.black.opacity(0.7))
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(tracker.gazePoint.show ? Color("millieYellow") : Color.gray.opacity(0.3))
                    )
                    .onTapGesture {
                        tracker.toggleGazePoint()
                    }
                
                Text("초기화")
                    .font(.subheadline)
                    .frame(height: 32)
                    .padding(.horizontal)
                    .foregroundColor(Color.gray)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.5))
                    )
                    .onTapGesture {
                        tracker.startCalibration()
                    }
            }
            .padding(.vertical, 4)
            .disabled(!tracker.isTracking)
            .opacity(tracker.isTracking ? 1 : 0.5)
        }
        .padding()
        .background(Color.white)
        
    }
}

struct TrackerSettingView_Previews: PreviewProvider {
    static var previews: some View {
        TrackerSettingView()
            .frame(width: UIScreen.main.bounds.width * 0.44)
            .previewLayout(.sizeThatFits)
    }
}
