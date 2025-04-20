//
//  Untitled.swift
//  SwiftUICrypto
//

import Combine
import Foundation

class HomeViewModel: ObservableObject {
    @Published var filteredCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var inputSearchText: String = ""
    @Published var marketData: MarketData?

    @Published var error: APIError?
    @Published var isShowError: Bool = false

    private var allCoins: [CoinModel] = []
    private var coinGeckoApi = CoinGeckoApi()
    private var portfolioRepository = PortfolioRepository()
    private var cancellables = Set<AnyCancellable>()

    init() {
        listenSearchKeyChanged()
        listenPortfolioUpdated()
    }

    func fetchCoins() {
        coinGeckoApi
            .fetchCoins()
            .map { coins in
                coins.map { coin in
                    var newCoin = coin
                    newCoin.favorite = Int.random(in: 1 ..< 10) < 3
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
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioRepository.updatePortfolio(coin: coin, amount: amount)
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
    
    private func listenPortfolioUpdated() {
        $filteredCoins
            .combineLatest(portfolioRepository.$savedCoins)
            .map { (coins, savedCoins) -> [CoinModel] in
                coins.compactMap { coin -> CoinModel? in
                    guard let coinEntity = savedCoins.first(where: { $0.coinID == coin.id }) else {
                        return nil
                    }
                    
                    return CoinModel(
                        coin: coin,
                        currentHolding: coinEntity.amount,
                        currentHoldingValue: coinEntity.amount * coin.currentPrice.valueOrZero()
                    )                    
                }
            }
            .sink { coins in
                self.portfolioCoins = coins
            }
            .store(in: &cancellables)
    }
}
