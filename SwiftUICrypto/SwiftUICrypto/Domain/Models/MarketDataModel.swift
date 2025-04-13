//
//  MarketDataModel.swift
//  SwiftUICrypto
//

import Foundation

struct MarketDataModel: Codable {
    let data: MarketData
}

struct MarketData: Codable {
    let activeCryptocurrencies: Int?
    let upcomingIcos: Int?
    let ongoingIcos: Int?
    let endedIcos: Int?
    let markets: Int?
    let totalMarketCap: [String: Double]?
    let totalVolume: [String: Double]?
    let marketCapPercentage: [String: Double]?
    let marketCapChangePercentage24hUsd: Double?
    let updatedAt: Int64?
    
    enum CodingKeys: String, CodingKey {
        case activeCryptocurrencies = "active_cryptocurrencies"
        case upcomingIcos = "upcoming_icos"
        case ongoingIcos = "ongoing_icos"
        case endedIcos = "ended_icos"
        case markets
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24hUsd = "market_cap_change_percentage_24h_usd"
        case updatedAt = "updated_at"
    }
    
    var totalMarketCapInUsd: Double {
        guard let totalMarketCapInUsd = totalMarketCap?["usd"] else { return 0 }
        return totalMarketCapInUsd
    }
    
    var totalVolumeInUsd: Double {
        guard let totalVolumeInUsd = totalVolume?["usd"] else { return 0 }
        return totalVolumeInUsd
    }
    
    var btcDominance: String {
        guard let btcPercentage = marketCapPercentage?["btc"] else { return "0.0%" }
        return btcPercentage.asPercentageString()
    }
}
