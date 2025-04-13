//
//  Optional+Extension.swift
//  SwiftUICrypto
//

extension Optional where Wrapped == Double {
    func valueOrZero() -> Double {
        self ?? 0.0
    }
}

extension Optional where Wrapped == Int {
    func valueOrZero() -> Int {
        self ?? 0
    }
}
