//
//  String+Extension.swift
//  SwiftUICrypto
//

import CryptoKit
import Foundation

extension String {
    func sha256() -> String {
        let data = Data(self.utf8)
        let digest = SHA256.hash(data: data)
        return digest.map { String(format: "%02x", $0) }.joined()
    }
    
    var isBlank: Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
