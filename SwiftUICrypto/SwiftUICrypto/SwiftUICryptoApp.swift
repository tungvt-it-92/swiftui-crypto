//
//  SwiftUICryptoApp.swift
//  SwiftUICrypto
//

import SwiftUI

@main
struct SwiftUICryptoApp: App {
    
    @State private var showLaunchView: Bool = true
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentColor)]
    }
    
    let homeViewModel = HomeViewModel()
    var body: some Scene {
        WindowGroup {
            ZStack {
                NavigationStack {
                    HomeView()
                }
                .environmentObject(homeViewModel)
             
                if showLaunchView {
                    LaunchView(showLaunchView: $showLaunchView)
                        .transition(.move(edge: .leading))
                } 
            }
        }
    }
}
