//
//  SwiftUICryptoApp.swift
//  SwiftUICrypto
//

import SwiftUI

@main
struct SwiftUICryptoApp: App {
    let homeViewModel = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
            }
        }
        .environmentObject(homeViewModel)
    }
}
