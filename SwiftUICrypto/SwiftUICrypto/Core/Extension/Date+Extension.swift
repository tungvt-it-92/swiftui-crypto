//
//  Date+Extension.swift
//  SwiftUICrypto
//
import Foundation

extension Date {
    init(iso8601String: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = formatter.date(from: iso8601String) ?? Date()
        
        self.init(timeInterval: 0, since: date)
    }
    
    var shortDateString: String {
        return shortFormatter.string(from: self)
    }
    
    var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: self)
    }
    
    private var shortFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "d/M/YY"
        
        return formatter
    }
}
