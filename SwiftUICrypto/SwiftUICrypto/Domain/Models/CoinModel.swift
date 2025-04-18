//
//  CoinModel.swift
//  SwiftUICrypto
//

import Foundation

struct CoinModel: Identifiable, Codable {
    init(
        id: String,
        symbol: String,
        name: String,
        marketCapRank: Int,
        image: String? = nil,
        currentPrice: Double? = nil,
        marketCap: Double? = nil,
        fullyDilutedValuation: Int64? = nil,
        totalVolume: Double? = nil,
        high24h: Double? = nil,
        low24h: Double? = nil,
        priceChange24h: Double? = nil,
        priceChangePercentage24h: Double? = nil,
        marketCapChange24h: Double? = nil,
        marketCapChangePercentage24h: Double? = nil,
        circulatingSupply: Double? = nil,
        totalSupply: Double? = nil,
        maxSupply: Double? = nil,
        ath: Double? = nil,
        athChangePercentage: Double? = nil,
        athDate: Date? = nil,
        atl: Double? = nil,
        atlChangePercentage: Double? = nil,
        atlDate: Date? = nil,
        roi: ROI? = nil,
        lastUpdated: Date? = nil,
        sparklineIn7d: Sparkline? = nil,
        favorite: Bool? = nil,
        currentHolding: Double? = nil,
        currentHoldingValue: Double? = nil) {
        
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.fullyDilutedValuation = fullyDilutedValuation
        self.totalVolume = totalVolume
        self.high24h = high24h
        self.low24h = low24h
        self.priceChange24h = priceChange24h
        self.priceChangePercentage24h = priceChangePercentage24h
        self.marketCapChange24h = marketCapChange24h
        self.marketCapChangePercentage24h = marketCapChangePercentage24h
        self.circulatingSupply = circulatingSupply
        self.totalSupply = totalSupply
        self.maxSupply = maxSupply
        self.ath = ath
        self.athChangePercentage = athChangePercentage
        self.athDate = athDate
        self.atl = atl
        self.atlChangePercentage = atlChangePercentage
        self.atlDate = atlDate
        self.roi = roi
        self.lastUpdated = lastUpdated
        self.sparklineIn7d = sparklineIn7d
        self.favorite = favorite
        self.currentHolding = currentHolding
        self.currentHoldingValue = currentHoldingValue
    }
    
    let id: String
    let symbol: String
    let name: String
    let marketCapRank: Int
    let image: String?
    let currentPrice: Double?
    let marketCap: Double?
    let fullyDilutedValuation: Int64?
    let totalVolume: Double?
    let high24h: Double?
    let low24h: Double?
    let priceChange24h: Double?
    let priceChangePercentage24h: Double?
    let marketCapChange24h: Double?
    let marketCapChangePercentage24h: Double?
    let circulatingSupply: Double?
    let totalSupply: Double?
    let maxSupply: Double?
    let ath: Double?
    let athChangePercentage: Double?
    let athDate: Date?
    let atl: Double?
    let atlChangePercentage: Double?
    let atlDate: Date?
    let roi: ROI?
    let lastUpdated: Date?
    let sparklineIn7d: Sparkline?
    var favorite: Bool?
    var currentHolding: Double?
    var currentHoldingValue: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24h = "high_24h"
        case low24h = "low_24h"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case marketCapChange24h = "market_cap_change_24h"
        case marketCapChangePercentage24h = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case roi
        case lastUpdated = "last_updated"
        case sparklineIn7d = "sparkline_in_7d"
        case favorite
        case currentHolding
        case currentHoldingValue
    }
}

struct Sparkline: Codable {
    let price: [Double]?
}

struct ROI: Codable {
    let times: Double?
    let currency: String?

    enum CodingKeys: String, CodingKey {
        case times
        case currency
    }
}
