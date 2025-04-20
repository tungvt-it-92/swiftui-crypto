//
//  PortfolioRepository.swift
//  SwiftUICrypto
//
import Foundation
import CoreData

class PortfolioRepository {
    @Published var savedCoins: [PortfolioCoinEntity] = []
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                MyLogger.debugLog("PortfolioRepository init error: \(error)")
            }
        }
        loadPortfolio()
    }
    
    // MARK: PUBLIC
    
    func loadPortfolio() {
        let request = NSFetchRequest<PortfolioCoinEntity>(entityName: "PortfolioCoinEntity")
        do {
            savedCoins = try container.viewContext.fetch(request)
        } catch {
            MyLogger.debugLog("PortfolioRepository loadPortfolio error: \(error)")
        }
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        if let entity = savedCoins.first(where: { $0.coinID == coin.id }) {
            entity.amount = amount
            if amount > 0 {
                updateCoin(entity: entity, amount: amount)
            } else {
                deleteCoin(entity: entity)
            }
        } else {
            
            addCoin(coin: coin, amount: amount)
        }
    }
    
    // MARK: PRIVATE
    
    func addCoin(coin: CoinModel, amount: Double) {
        let newCoin = PortfolioCoinEntity(context: container.viewContext)
        newCoin.amount = amount
        newCoin.coinID = coin.id
        updateContext()
    }
    
    private func updateCoin(entity: PortfolioCoinEntity, amount: Double) {
        entity.amount = amount
        updateContext()
    }
    
    private func deleteCoin(entity: PortfolioCoinEntity) {
        container.viewContext.delete(entity)
        updateContext()
    }
    
    private func updateContext() {
        do {
            try container.viewContext.save()
            loadPortfolio()
        } catch let error {
            MyLogger.debugLog("PortfolioRepository saveContext error: \(error)")
        }
    }
}

