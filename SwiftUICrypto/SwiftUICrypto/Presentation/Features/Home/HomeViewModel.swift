//
//  Untitled.swift
//  SwiftUICrypto
//

import Combine
import Foundation

enum SortCoinOption {
    case rank
    case rankReversed
    case holdings
    case holdingsReversed
    case change24h
    case change24hReversed
    case price
    case priceReversed
}

@MainActor
class HomeViewModel: BaseViewModel {
    @Published var filteredCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var favoriteCoins: [CoinModel] = []
    @Published var inputSearchText: String = ""
    @Published var statistics: [StatisticModel] = []
    @Published var sortOption: SortCoinOption = .rank
    @Published private var marketData: MarketData?
    
    @Published private var allCoins: [CoinModel] = []
    private var coinGeckoApi: CoinGeckoApiProtocol = CoinGeckoApi()
    private var portfolioRepository = PortfolioRepository()
    private var favoriteCoinRepository = FavoriteCoinRepository()
    
    override init() {
        super.init()
        listenSearchKeyChanged()
        listenPortfolioUpdated()
        listenMarketDataUpdated()
        listenFavoriteCoinsUpdated()
    }
    
    // MARK: PUBLIC
    
    func fetchCoins() {
        coinGeckoApi
            .fetchCoins()
            .catch { [weak self] error -> AnyPublisher<[CoinModel], Never> in
                self?.error = error
                return Just<[CoinModel]>([])
                    .eraseToAnyPublisher()
            }
            .combineLatest(favoriteCoinRepository.$favoriteCoins)
            .map(mapFavoriteCoins)
            .sink(receiveValue: { [weak self] coins in
                self?.allCoins = coins
                self?.filteredCoins = coins
            })
            .store(in: &cancellables)
    }
    
    func fetchMarketData() {
        coinGeckoApi
            .fetchMarketData()
            .catch { [weak self] error -> Empty<MarketDataModel, Never> in
                self?.error = error
                return Empty(completeImmediately: true)
            }
            .sink(receiveValue: { [weak self] marketData in
                self?.marketData = marketData.data
            })
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioRepository.updatePortfolio(coin: coin, amount: amount)
    }
    
    func refresh() {
        isLoading = true
        fetchCoins()
        fetchMarketData()
        HapticFeedback.notify(type: .success)
    }
    
    func toggleFavorite(coin: CoinModel) {
        if coin.favorite == true {
            favoriteCoinRepository.deleteCoin(coinID: coin.id)
        } else {
            favoriteCoinRepository.addCoin(coin: coin)
        }
    }
    
    // MARK: PRIVATE
    
    private func listenSearchKeyChanged() {
        $inputSearchText
            .debounce(for: .seconds(0.3), scheduler: DispatchQueue.main)
            .combineLatest($allCoins, $sortOption)
            .map { [weak self] (searchKey, allCoins, option) -> [CoinModel] in
                guard let self = self else { return [] }
                
                let filteredCoins = filterCoins(filterKey: searchKey, coins: allCoins)
                
                return sortCoins(sortOption: option, coins: filteredCoins)
            }
            .sink { [weak self] returnedCoins in
                self?.filteredCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    private func listenPortfolioUpdated() {
        $filteredCoins
            .combineLatest(portfolioRepository.$savedCoins, $sortOption)
            .map { [weak self] (coins, savedCoins, option) -> [CoinModel] in
                guard let self = self else { return [] }
                let portfolioCoins = coins.compactMap { coin -> CoinModel? in
                    guard let coinEntity = savedCoins.first(where: { $0.coinID == coin.id }) else {
                        return nil
                    }
                    
                    return CoinModel(
                        coin: coin,
                        currentHolding: coinEntity.amount,
                        currentHoldingValue: coinEntity.amount * coin.currentPrice.valueOrZero(),
                        favorite: coin.favorite ?? false
                    )
                }
                return self.sortPortfolioCoins(sortOption: option, coins: portfolioCoins)
            }
            .sink { [weak self] coins in
                guard let self = self else { return }
                
                portfolioCoins = coins
            }
            .store(in: &cancellables)
    }
    
    private func listenFavoriteCoinsUpdated() {
        $filteredCoins
            .combineLatest($sortOption)
            .map { [weak self] (coins, option) -> [CoinModel] in
                guard let self = self else { return [] }
                let favoriteCoins = coins.filter { $0.favorite == true }
                
                return self.sortCoins(sortOption: option, coins: favoriteCoins)
            }
            .sink { [weak self] coins in
                self?.favoriteCoins = coins
            }
            .store(in: &cancellables)
    }
    
    private func listenMarketDataUpdated() {
        $marketData
            .combineLatest($portfolioCoins)
            .sink { [weak self] (market, portfolioCoins) in
                guard let self = self, let market = market else { return }
                let portfolioCurrentValue = portfolioCoins
                    .map{ $0.currentHoldingValue.valueOrZero() }
                    .reduce(0, +)
                
                let portfolioPreviousValues = portfolioCoins
                    .map { (coin) -> Double in
                        let currentValue = coin.currentHoldingValue.valueOrZero()
                        let percentChange = coin.priceChangePercentage24h.valueOrZero()
                        let previousValue = currentValue / (1 + percentChange/100)
                        
                        return previousValue
                    }
                    .reduce(0, +)
                
                let portfolioPercentageChange = portfolioPreviousValues > 0
                                                ? ((portfolioCurrentValue - portfolioPreviousValues) / portfolioPreviousValues) * 100
                                                : nil
                
                statistics = [
                    StatisticModel(
                        title: "Market Cap",
                        value: market.totalMarketCapInUsd.formattedWithAbbreviations()
                    ),
                    StatisticModel(
                        title: "24h Volume",
                        value: market.totalVolumeInUsd.formattedWithAbbreviations()
                    ),
                    StatisticModel(
                        title: "BTC Dominance",
                        value: market.btcDominance
                    ),
                    StatisticModel(
                        title: "Portfolio",
                        value: portfolioCurrentValue.formattedWithAbbreviations(),
                        percentageChange: portfolioPercentageChange
                    ),
                ]
                
            }
            .store(in: &cancellables)
    }
    
    private func filterCoins(filterKey: String, coins: [CoinModel]) -> [CoinModel] {
        let filteredCoins = coins.filter {
            filterKey.isEmpty
            || $0.symbol.lowercased().contains(filterKey.lowercased())
            || $0.name.lowercased().contains(filterKey.lowercased())
            || $0.id.lowercased().contains(filterKey.lowercased())
        }
        
        return filteredCoins
    }
    
    private func sortCoins(sortOption: SortCoinOption, coins: [CoinModel]) -> [CoinModel] {
        return coins.sorted { coin1, coin2 in
            switch sortOption {
            case .rank, .holdings:
                return coin1.marketCapRank < coin2.marketCapRank
            case .rankReversed, .holdingsReversed:
                return coin1.marketCapRank > coin2.marketCapRank
            case .change24h:
                return coin1.high24h.valueOrZero() - coin1.low24h.valueOrZero() < coin2.high24h.valueOrZero() - coin2.low24h.valueOrZero()
            case .change24hReversed:
                return coin1.high24h.valueOrZero() - coin1.low24h.valueOrZero() > coin2.high24h.valueOrZero() - coin2.low24h.valueOrZero()
            case .price:
                return coin1.currentPrice.valueOrZero() < coin2.currentPrice.valueOrZero()
            case .priceReversed:
                return coin1.currentPrice.valueOrZero() > coin2.currentPrice.valueOrZero()
            }
        }
    }
    
    private func sortPortfolioCoins(sortOption: SortCoinOption, coins: [CoinModel]) -> [CoinModel] {
        if sortOption == .holdings || sortOption == .holdingsReversed {
            return coins.sorted {
                sortOption == .holdings
                ? $0.currentHoldingValue.valueOrZero() < $1.currentHoldingValue.valueOrZero()
                : $0.currentHoldingValue.valueOrZero() > $1.currentHoldingValue.valueOrZero()
            }
        }
        
        return coins
    }
    
    private func mapFavoriteCoins(coins: [CoinModel], favoriteCoinEntities: [FavoriteCoinEntity]) -> [CoinModel] {
        let favoriteCoinById = Dictionary(uniqueKeysWithValues: favoriteCoinEntities.map { ($0.coinID, $0) })
        
        return coins.map { coin -> CoinModel in
            if favoriteCoinById[coin.id] != nil {
                return  CoinModel(coin: coin, favorite: true)
            }
            
            return coin
        }
    }
}
