//
//  AnimatedCircleButton.swift
//  SwiftUICrypto
//

import SwiftUI

struct AnimatedCircleView: View {
    let isAnimating: Bool
    let scaleFrom: Double
    let scaleTo: Double
    let opacityFrom: Double
    let opacityTo: Double
    
    init(
        isAnimating: Bool,
        scaleFrom: Double = 0.0,
        scaleTo: Double = 1.3,
        opacityFrom: Double = 1.0,
        opacityTo: Double = 0.0
    ) {
        self.isAnimating = isAnimating
        self.scaleFrom = scaleFrom
        self.scaleTo = scaleTo
        self.opacityFrom = opacityFrom
        self.opacityTo = opacityTo
    }
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 3.0)
            .scaleEffect(isAnimating ? scaleTo : scaleFrom, anchor: .center)
            .opacity(isAnimating ? opacityTo : opacityFrom)
            .animation(
                isAnimating ? .spring : nil,
                value: isAnimating
            )
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var isAnimating = false
        
        var body: some View {
            AnimatedCircleView(isAnimating: isAnimating)
                .onAppear {
                    isAnimating.toggle()
            }
        }
    }
    
    return PreviewWrapper()
}
