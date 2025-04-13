import Foundation

//
//  Double.swift
//  SwiftUICrypto
//

extension Double {
    private var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "en_US")
        formatter.minimumFractionDigits = 2
        
        return formatter
    }
    ///
    ///```
    ///Convert to US currency format
    ///```
    ///
    func asCurrency() -> String {
        let number = NSNumber(value: self)
        
        return currencyFormatter.string(from: number) ?? "$0.00"
    }
    
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    func asPercentageString() -> String {
        return String(format: "%.2f%", self)
    }
}
