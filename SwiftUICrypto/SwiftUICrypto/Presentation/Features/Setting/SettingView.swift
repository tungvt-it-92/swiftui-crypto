//
//  SettingView.swift
//  SwiftUICrypto
//
//  Created by Tung Vu on 2025/04/26.
//

import SwiftUI

struct SettingView: View {
    private let myAppsLink = "https://apps.apple.com/us/developer/tien-tung-vu/id1492886876"
    private let termOfUseLink: String = "https://www.coingecko.com/en/terms"
    private let privacyLink: String = "https://www.coingecko.com/en/privacy"
    @State private var appVersion: String = ""
    @State private var appBuildNumber: String = ""
    
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("CryptoTracker")
                    .foregroundStyle(Color.theme.secondaryTextColor)
                    .fontWeight(.bold)
                ) {
                    HStack(alignment: .top) {
                        Image("ic_logo")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        Text("Stay ahead of the market! Track real-time crypto prices, monitor trends, and manage your favorite coins effortlessly. Fast, sleek, and built for crypto enthusiasts")
                    }
                    
                    if !appVersion.isEmpty, !appBuildNumber.isEmpty {
                        Text("App version: \(appVersion)(\(appBuildNumber))")
                    }
                }
                .font(.callout)
                .foregroundStyle(Color.theme.accentColor)
                
                Section(header: Text("Application")
                    .fontWeight(.bold)
                    .font(.headline)
                    .foregroundStyle(Color.theme.secondaryTextColor)
                ) {
                    SwiftUI.Link("Term Of Use", destination: URL(string: termOfUseLink)!)
                        .foregroundStyle(Color.blue)
                    SwiftUI.Link("Privacy Policy",destination: URL(string: privacyLink)!)
                        .foregroundStyle(Color.blue)
                    SwiftUI.Link("My Other Apps", destination: URL(string: myAppsLink)!)
                        .foregroundStyle(Color.blue)
                }
                
            }
            .listStyle(.grouped)
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    BackButton()
                }
            }
            .onAppear {
                if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                    appVersion = version
                }
                if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                    appBuildNumber = build
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
