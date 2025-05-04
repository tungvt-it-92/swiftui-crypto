//
//  CoinMarketProvider.swift
//  SwiftUICrypto
//

import Foundation
import WidgetKit
import SwiftUI

struct CoinMarketProvider: TimelineProvider {
    private let favoriteRepository = FavoriteCoinRepository(appGroupID: Constant.appGroupID)
    private let coinGeckoApi = CoinGeckoApi()
    private let imageService = NetworkImageService()
    
    func placeholder(in context: Context) -> CoinWidgetEntry {
        CoinWidgetEntry(date: Date(), coins: [], coinImageById: [:])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (CoinWidgetEntry) -> Void) {
        let entry = CoinWidgetEntry(date: Date(), coins: [], coinImageById: [:])
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<CoinWidgetEntry>) -> Void) {
        Task { @MainActor in
            var entries: [CoinWidgetEntry] = []
            
            do {
                // Fetch favorite coins
                let favoriteCoins: [FavoriteCoinEntity] = await favoriteRepository.fetchFavoriteCoinsAsync()
                var trackingCoinIds = favoriteCoins.prefix(2).compactMap { $0.coinID }
                trackingCoinIds = trackingCoinIds.isEmpty ? ["bitcoin"] : trackingCoinIds
                
                // Fetch market data
                let coins = try await coinGeckoApi.fetchCoins(ids: trackingCoinIds).asyncValue()
                var coinImageById: [String: UIImage] = [:]
                for coinMarket in coins {
                    // Try downloading image
                    let coinImage: UIImage? = await {
                        guard let imageUrl = coinMarket.image else { return nil }
                        return await imageService.downloadImageAsync(imageUrl: imageUrl)
                    }()
                    coinImageById[coinMarket.id] = coinImage
                }
                
                let entry = CoinWidgetEntry(date: Date(), coins: coins, coinImageById: coinImageById )
                entries.append(entry)
            } catch {
                MyLogger.debugLog("⚠️ Widget timeline fetch error: \(error)")
            }
            
            let timeline = Timeline(entries: entries, policy: .after(Date().addingTimeInterval(15 * 60)))
            completion(timeline)
        }
    }
}