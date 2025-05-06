//
//  SwiftUICryptoApp.swift
//  SwiftUICrypto
//

import SwiftUI

@main
struct SwiftUICryptoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var showLaunchView: Bool = true
    let homeViewModel = HomeViewModel()

    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentColor)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.theme.accentColor)]
    }

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
            .onPreferenceChange(SupportedOrientationsPreferenceKey.self) { newOrientation in
                Task { @MainActor in
                    if let newOrientation = newOrientation {
                        AppDelegate.shared.updateSupportedInterfaceOrientationsInUI(newOrientationLock: newOrientation)
                    }
                }
            }
        }
    }
}
