//
//  AppDelegate.swift
//  SwiftUICrypto
//
import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    
    static let shared = AppDelegate()
    private var orientationLock = UIInterfaceOrientationMask.portrait
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.shared.orientationLock
    }
    
    func updateSupportedInterfaceOrientationsInUI(newOrientationLock: UIInterfaceOrientationMask) {
        UIApplication.shared.connectedScenes.forEach { scene in
            if let windowScene = scene as? UIWindowScene {
                AppDelegate.shared.orientationLock = newOrientationLock
                windowScene.requestGeometryUpdate(
                    .iOS(interfaceOrientations: newOrientationLock)
                )
                windowScene.keyWindow?.rootViewController?.setNeedsUpdateOfSupportedInterfaceOrientations()
            }
        }
    }
}
