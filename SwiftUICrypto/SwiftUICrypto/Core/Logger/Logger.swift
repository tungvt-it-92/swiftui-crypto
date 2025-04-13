//
//  Logger.swift
//  SwiftUICrypto
//

import os
import Foundation

struct MyLogger {
    private static let logger = Logger(
        subsystem: Bundle.main.bundleIdentifier!,
        category: String(describing: "Logger")
    )
    
    static func debugLog(_ message: Any...) {
#if DEBUG
        logger.debug("\(message)")
#endif
    }
}
