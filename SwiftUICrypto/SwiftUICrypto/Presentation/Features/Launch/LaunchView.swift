//
//  LaunchView.swift
//  SwiftUICrypto

import SwiftUI

struct LaunchView: View {
    
    @Binding var showLaunchView: Bool
    
    @State private var loadingText: [String] = "Loading your portfolio...".map { String($0) }
    @State private var showLoadingText: Bool = false
    @State private var animatingIndex: Int = 0
    private var timer = Timer.publish(every: 0.07, on: .main, in: .common).autoconnect()
    @State private var animationLoops = 0
    
    init(showLaunchView: Binding<Bool>) {
        _showLaunchView = showLaunchView
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Color.launch.background
                .ignoresSafeArea()
            
            Image("ic_logo")
                .resizable()
                .frame(width: 140, height: 140)
                .ignoresSafeArea()
            
            if showLoadingText {
                HStack(spacing: 0) {
                    ForEach(0..<loadingText.count, id: \.self) { index in
                        Text(loadingText[index])
                            .font(.headline)
                            .fontWeight(.heavy)
                            .foregroundStyle(Color.launch.accent)
                            .offset(y: animatingIndex == index ? -15 : 0)
                    }
                }
                .offset(y: 80)
            }
            
        }
        .animation(.spring, value: animatingIndex)
        .onReceive(timer, perform: { _ in
            if animatingIndex == loadingText.count - 1 {
                animatingIndex = 0
                animationLoops += 1
            } else {
                animatingIndex += 1
            }
            if animationLoops > 1 {
                showLaunchView = false
            }
        })
        .onAppear {
            showLoadingText.toggle()
        }
    }
}


#if DEBUG

#Preview {
    LaunchView(showLaunchView: .constant(true))
}

#endif
