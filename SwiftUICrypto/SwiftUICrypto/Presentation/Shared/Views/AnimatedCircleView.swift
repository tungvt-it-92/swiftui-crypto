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
    @State var internalIsAnimating: Bool
    
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
        internalIsAnimating = !isAnimating
    }
    
    var body: some View {
        Circle()
            .stroke(lineWidth: 3.0)
            .scaleEffect(internalIsAnimating ? scaleTo : scaleFrom, anchor: .center)
            .opacity(internalIsAnimating ? opacityTo : opacityFrom)
            .animation(
                internalIsAnimating ? .spring : nil,
                value: internalIsAnimating
            )
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    internalIsAnimating.toggle()
                }
            }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var isAnimating = true
        
        var body: some View {
            AnimatedCircleView(isAnimating: isAnimating)
        }
    }
    
    return PreviewWrapper()
}
