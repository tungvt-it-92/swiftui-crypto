//
//  HapticFeedback.swift
//  SwiftUICrypto
//
import Foundation
import SwiftUI

struct HapticFeedback {
    static private var hapticFeedbackGenerator = UINotificationFeedbackGenerator()
    
    static func notify(type: UINotificationFeedbackGenerator.FeedbackType) {
        hapticFeedbackGenerator.notificationOccurred(type)
    }
}

