//
//  Untitled.swift
//  SwiftUICrypto
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var filteredCoins: [CoinModel] = []
    @Published var inputSearchText: String = ""
    @Published var marketData: MarketData?

    @Published var error: APIError?
    @Published var isShowError: Bool = false

    private var allCoins: [CoinModel] = []
    private var coinGeckoApi = CoinGeckoApi()
    private var cancellables = Set<AnyCancellable>()

    init() {
        listenSearchKeyChanged()
    }

    func fetchCoins() {
        coinGeckoApi
            .fetchCoins()
            .map { coins in
                coins.map { coin in
                    var newCoin = coin
                    newCoin.favorite = Int.random(in: 1 ..< 10) < 3
                    newCoin.currentHolding = Double.random(in: 100 ..< 10000)
                    newCoin.currentHoldingValue = Double.random(in: 100 ..< 1000)

                    return newCoin
                }
            }
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    MyLogger.debugLog("FetchCoins FINISHED")
                case let .failure(error):
                    MyLogger.debugLog("ERROR \(error.localizedDescription)")
                    self?.error = error
                    self?.isShowError = true
                }
            } receiveValue: { [weak self] coins in
                self?.allCoins = coins
                self?.filteredCoins = coins
            }
            .store(in: &cancellables)
    }

    func fetchMarketData() {
        coinGeckoApi
            .fetchMarketData()
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    MyLogger.debugLog("fetchMarketData FINISHED")
                case let .failure(error):
                    MyLogger.debugLog("ERROR \(error.localizedDescription)")
                    self?.error = error
                    self?.isShowError = true
                }
            } receiveValue: { [weak self] marketData in
                self?.marketData = marketData.data
            }
            .store(in: &cancellables)
    }

    private func listenSearchKeyChanged() {
        $inputSearchText
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .sink { [weak self] value in
                self?.filteredCoins = self?.allCoins.filter {
                    value.isEmpty
                        || $0.symbol.lowercased().contains(value.lowercased())
                        || $0.name.lowercased().contains(value.lowercased())
                        || $0.id.lowercased().contains(value.lowercased())
                } ?? []
            }
            .store(in: &cancellables)
    }
}
