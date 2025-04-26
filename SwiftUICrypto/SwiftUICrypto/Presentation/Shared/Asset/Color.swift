//
//  Color.swift
//  SwiftUICrypto
//

import SwiftUICore

extension Color {
    static let theme = ColorThem()
    static let launch = LaunchTheme()
}

struct ColorThem {
    let accentColor = Color("AccentColor")
    let background = Color("Background")
    let greenColor = Color("GreenColor")
    let redColor = Color("RedColor")
    let secondaryTextColor = Color("SecondaryTextColor")
}

struct LaunchTheme {
    let accent = Color("LaunchAccentColor")
    let background = Color("LaunchBackgroundColor")
}
