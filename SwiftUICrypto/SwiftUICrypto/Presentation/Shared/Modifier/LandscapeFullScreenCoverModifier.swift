//
//  LandscapeFullScreenCoverModifier.swift
//  SwiftUICrypto
//
import SwiftUI

struct LandscapeFullScreenCoverModifier<CoverContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @ViewBuilder let coverContent: () -> CoverContent

    func body(content: Content) -> some View {
        content
            .fullScreenCover(isPresented: $isPresented) {
                coverContent()
            }
            .supportedOrientations(isPresented ? .landscapeRight : .portrait)
    }
}

extension View {
    func landscapeFullScreenCover(isPresented: Binding<Bool>, @ViewBuilder content: @escaping () -> some View) -> some View {
        modifier(LandscapeFullScreenCoverModifier(isPresented: isPresented, coverContent: content))
    }

    func supportedOrientations(_ supportedOrientations: UIInterfaceOrientationMask) -> some View {
        return preference(key: SupportedOrientationsPreferenceKey.self, value: supportedOrientations)
    }
}

struct SupportedOrientationsPreferenceKey: PreferenceKey {
    static let defaultValue: UIInterfaceOrientationMask? = nil

    static func reduce(value: inout UIInterfaceOrientationMask?, nextValue: () -> UIInterfaceOrientationMask?) {
        if let next = nextValue() {
            value = next
        }
    }
}
