//
//  Untitled.swift
//  SwiftUICrypto
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    private var coinGeckoApi = CoinGeckoApi()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchCoins() async {
        coinGeckoApi
            .fetchCoins()
            .sink { completion in
                switch completion {
                case .finished:
                    MyLogger.debugLog("FINISHED")
                case .failure(let error):
                    MyLogger.debugLog("ERROR \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] coins in
                self?.allCoins = coins
            }
            .store(in: &cancellables)
    }
}
