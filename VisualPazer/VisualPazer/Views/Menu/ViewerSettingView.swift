//
//  ViewerSettingView.swift
//  VisualPazer
//
//  Created by 이윤지 on 2021/06/08.
//

import SwiftUI


struct ViewerSettingView : View {
    
    let colorPalette : [Color] = [Color(#colorLiteral(red: 1, green: 0.9521923661, blue: 0.8424096704, alpha: 1)), Color(#colorLiteral(red: 0.9075901209, green: 0.9649860507, blue: 0.8448821898, alpha: 1)), Color(#colorLiteral(red: 0.1632906497, green: 0.325476259, blue: 0.1988659799, alpha: 1)), Color(#colorLiteral(red: 0.4980838895, green: 0.4951269031, blue: 0.5003594756, alpha: 1)), Color(#colorLiteral(red: 0.244676441, green: 0.2432282567, blue: 0.2457937598, alpha: 1))]
    
    var body : some View {
        VStack(spacing: 16) {
            // color & brightness settting
            color
            brightness
            Divider()
            
            // viewer setting
            viewer
            Divider()
            
            // page & gesture setting
            page
            gesture
            
            // init button
            initialize
        }
        .padding()
        .background(Color.white)
    }
    
    var color: some View {
        HStack {
            Capsule()
                .fill(Color.white)
                .overlay(
                    Capsule()
                        .stroke(Color("millieYellow"), lineWidth: 2)
                )
                .frame(width: 40)
            ForEach(colorPalette, id: \.self) { color in
                Capsule()
                    .fill(color)
                    .frame(width: 40)
            }
            Capsule()
                .frame(width: 40)
                .overlay(
                    Image(systemName: "moon")
                        .foregroundColor(.white)
                )
        }
        .frame(height: 28)
    }
    
    var brightness: some View {
        HStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40),
                    alignment: .leading
                )
                .overlay(
                    HStack {
                        Label("밝기", systemImage: "sun.max")
                        Spacer()
                        Text("10")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                )
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.gray.opacity(0.2))
                .frame(width: 40)
                .overlay(
                    Image(systemName: "iphone")
                )
        }
        .foregroundColor(.gray)
        .frame(height: 40)
    }
    
    var viewer: some View {
        HStack {
            Text("보기 설정")
                .font(.subheadline)
            Image(systemName: "questionmark.circle")
            Spacer()
            Image(systemName: "chevron.down")
        }
    }
    
    var page: some View {
        VStack(spacing: 16) {
            ViewerSettingButton(
                title: "페이지 넘김 방향",
                labels: ["가로", "스크롤"],
                selected: 0
            )
            ViewerSettingButton(
                title: "페이지 넘김 효과",
                labels: ["슬라이드", "책넘기기", "없음"],
                selected: 2
            )
            ViewerSettingToggle(
                title: "볼륨키로 넘기기",
                description: "눈동자의 움직임을 추적하여 페이지를 넘깁니다."
            )
            ViewerSettingToggle(
                title: "가로모드에서 두 쪽 보기",
                description: "가로로 회전 시, 한 화면에 두 페이지씩 모아봅니다."
            )
            ViewerSettingToggle(
                title: "좌우영역 탭하여 넘기기",
                description: "본문 영역의 ¼을 탭하여 페이지를 넘깁니다.",
                isOn: true
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 0.2)
        )
    }
    
    var gesture: some View {
        VStack(alignment: .leading, spacing: 16) {
            ViewerSettingToggle(
                title: "상하제스처 밝기 조절",
                description: "상하 제스처로 뷰어를 밝히거나 어둡게 조절합니다"
            )
            ViewerSettingToggle(
                title: "화면 항상 켜짐",
                description: "책을 읽는 동안 화면이 꺼지지 않습니다."
            )
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.black, lineWidth: 0.2)
        )
    }

    var initialize : some View {
        Label("설정 초기화", systemImage: "arrow.clockwise")
            .font(.subheadline)
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(Color.black, lineWidth: 0.2)
            )
    }
}

struct ViewerSettingButton: View {
    let title: String
    let labels: [String]
    @State var selected: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline)
            HStack {
                ForEach((0..<labels.count)) { i in
                    Text(labels[i])
                        .font(.subheadline)
                        .foregroundColor(Color.black.opacity(0.7))
                        .frame(maxWidth: .infinity)
                        .frame(height: 32)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(i == selected ? Color("millieYellow") : Color.gray.opacity(0.3))
                        )
                        .onTapGesture {
                            selected = i
                        }
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ViewerSettingToggle: View {
    let title: String
    let description: String
    @State var isOn : Bool = false
    
    var body: some View {
        Toggle(isOn: $isOn) {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .toggleStyle(SwitchToggleStyle(tint: Color("millieYellow")))
    }
}

struct ViewerSettingView_Previews: PreviewProvider {
    static var previews: some View {
        ViewerSettingView()
            .frame(width: UIScreen.main.bounds.width * 0.44)
            .previewLayout(.sizeThatFits)
    }
}
