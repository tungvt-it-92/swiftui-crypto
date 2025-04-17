//
//  SwiftUICryptoApp.swift
//  SwiftUICrypto
//

import SwiftUI

@main
struct SwiftUICryptoApp: App {
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentColor)]
    }
    
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
