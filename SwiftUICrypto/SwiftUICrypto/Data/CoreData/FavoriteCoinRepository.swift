//
//  PortfolioRepository.swift
//  SwiftUICrypto
//
import Foundation
import CoreData

class FavoriteCoinRepository: BaseRepository {
    @Published var favoriteCoins: [FavoriteCoinEntity] = []
    
    override init(appGroupID: String) {
        super.init(appGroupID: appGroupID)
        loadFavoriteCoins()
    }
    
    
    // MARK: PUBLIC
    
    func loadFavoriteCoins() {
        let request = NSFetchRequest<FavoriteCoinEntity>(entityName: "FavoriteCoinEntity")
        do {
            favoriteCoins = try container.viewContext.fetch(request)
        } catch {
            MyLogger.debugLog("FavoriteCoinRepository loadPortfolio error: \(error)")
        }
    }
    
    func fetchFavoriteCoinsAsync() async -> [FavoriteCoinEntity] {
        var favoriteCoins: [FavoriteCoinEntity] = []
        let request = NSFetchRequest<FavoriteCoinEntity>(entityName: "FavoriteCoinEntity")
        
        do {
            favoriteCoins = try container.viewContext.fetch(request)
        } catch {
            MyLogger.debugLog("FavoriteCoinRepository fetchFavoriteCoinsAsync error: \(error)")
        }
        
        return favoriteCoins
    }
    
    func addCoin(coin: CoinModel) {
        if favoriteCoins.first(where: { $0.coinID == coin.id }) != nil {
            return
        }
        
        let newCoin = FavoriteCoinEntity(context: container.viewContext)
        newCoin.name = coin.name
        newCoin.coinID = coin.id
        updateContext()
    }
    
    
    func deleteCoin(coinID: String) {
        guard let coinEntity = favoriteCoins.first(where: { $0.coinID == coinID }) else {
            return
        }
        container.viewContext.delete(coinEntity)
        updateContext()
    }
    
    private func updateContext() {
        do {
            try container.viewContext.save()
            loadFavoriteCoins()
        } catch let error {
            MyLogger.debugLog("FavoriteCoinRepository saveContext error: \(error)")
        }
    }
}

