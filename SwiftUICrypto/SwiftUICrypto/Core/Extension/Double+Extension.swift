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
        return String(format: "%.2f%%", self)
    }
    
    func formattedWithAbbreviations() -> String {
        let num = abs(self)
        let sign = self < 0 ? "-" : ""
        
        switch num {
        case ..<1_000:
            return String(format: "$%@%.2f", sign, num)
        case 1_000..<1_000_000:
            return String(format: "$%@%.2fK", sign, num / 1_000)
        case 1_000_000..<1_000_000_000:
            return String(format: "$%@%.2fM", sign, num / 1_000_000)
        case 1_000_000_000..<1_000_000_000_000:
            return String(format: "$%@%.2fBn", sign, num / 1_000_000_000)
        case 1_000_000_000_000...:
            return String(format: "$%@%.2fTn", sign, num / 1_000_000_000_000)
        default:
            return String(format: "$%@%.2f", sign, num)
        }
    }
}
