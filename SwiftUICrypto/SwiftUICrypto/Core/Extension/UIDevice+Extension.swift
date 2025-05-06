//
//  UIDevice+Extension.swift
//  SwiftUICrypto
//
import UIKit

extension UIDevice {
    var isPad: Bool {
        userInterfaceIdiom == .pad
    }
}
