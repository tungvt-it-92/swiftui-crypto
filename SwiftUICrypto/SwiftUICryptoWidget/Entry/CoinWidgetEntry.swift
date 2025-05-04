//
//  CoinEntity.swift
//  SwiftUICrypto
//

import Foundation
import WidgetKit
import SwiftUI

struct CoinWidgetEntry: TimelineEntry {
    let date: Date
    let coins: [CoinModel]
    let coinImageById: [String: UIImage]
}


