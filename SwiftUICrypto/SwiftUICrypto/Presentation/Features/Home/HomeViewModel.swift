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
    @Published var isSearchingCoin: Bool = false
    
    @Published private var marketData: MarketData?
    @Published private var originalCoins: [CoinModel] = []
    private var coinGeckoApi: CoinGeckoApiProtocol = CoinGeckoApi()
    private var portfolioRepository = PortfolioRepository(appGroupID: Constant.appGroupID)
    private var favoriteCoinRepository = FavoriteCoinRepository(appGroupID: Constant.appGroupID)
    
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
            .fetchCoins(ids: nil)
            .catch { [weak self] error -> AnyPublisher<[CoinModel], Never> in
                self?.error = error
                return Empty(completeImmediately: true)
                    .eraseToAnyPublisher()
            }
            .combineLatest(syncLocalCoinsWithRemote(), searchRemoteCoins())
            .map { [weak self] (originalCoins, syncCoins, searchRemoteCoins) -> [CoinModel] in
                guard let `self` = self else { return [] }
                return combineCoins(originalCoins: originalCoins, syncCoins: syncCoins, searchRemoteCoins: searchRemoteCoins)
            }
            .combineLatest(favoriteCoinRepository.$favoriteCoins)
            .print("fetchCoins")
            .map(mapFavoriteCoins)
            .removeDuplicates()
            .sink(receiveValue: { [weak self] coins in
                self?.updateOriginalCoins(coins: coins)
            })
            .store(in: &cancellables)
    }
    
    func syncLocalCoinsWithRemote() -> AnyPublisher<[CoinModel], Never> {
        let localCoinIDs = Set(favoriteCoinRepository.favoriteCoins.map(\.coinID))
            .union(portfolioRepository.savedCoins.map(\.coinID))
        
        let idsList = Array(localCoinIDs).compactMap { $0 }
        
        guard !idsList.isEmpty else { return Just([]).eraseToAnyPublisher() }
        
        return coinGeckoApi.fetchCoins(ids: idsList)
            .catch { [weak self] error -> AnyPublisher<[CoinModel], Never> in
                self?.error = error
                return Empty(completeImmediately: true).eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
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
            .removeDuplicates()
            .combineLatest($originalCoins, $sortOption)
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
    
    private func searchRemoteCoins() -> AnyPublisher<[CoinModel], Never> {
        $inputSearchText
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map { [weak self] queryString -> AnyPublisher<[CoinModel], Never> in
                guard let self = self, !queryString.isBlank else {
                    return Just([]).eraseToAnyPublisher()
                }
                
                
                isSearchingCoin = true
                return coinGeckoApi.searchCoin(query: queryString)
                    .print("searchRemoteCoins")
                    .replaceError(with: [])
                    .handleEvents(receiveCompletion: { [weak self] _ in
                        self?.isSearchingCoin = false
                    }, receiveCancel: { [weak self] in
                        self?.isSearchingCoin = false
                    })
                    .eraseToAnyPublisher()
            }
            .switchToLatest()
            .eraseToAnyPublisher()
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
    
    private func updateOriginalCoins(coins: [CoinModel]) {
        var existingCoins = originalCoins
        let newCoinsByIds = Dictionary(uniqueKeysWithValues: coins.map{ ($0.id, $0) })
        existingCoins = existingCoins.map { newCoinsByIds[$0.id] ?? $0  }
        let existingCoinById = Dictionary(uniqueKeysWithValues: existingCoins.map{ ($0.id, $0) })
        
        for newCoin in coins where existingCoinById[newCoin.id] == nil  {
            existingCoins.append(newCoin)
        }
        
        originalCoins = existingCoins
    }
    
    private func combineCoins(originalCoins: [CoinModel], syncCoins: [CoinModel], searchRemoteCoins: [CoinModel]) -> [CoinModel] {
        let newSyncCoins = syncCoins.filter { coin in
            !originalCoins.contains(where: { $0.id == coin.id })
        }
        let newSearchCoins = searchRemoteCoins.filter { coin in
            !originalCoins.contains(where: { $0.id == coin.id }) &&
            !syncCoins.contains(where: { $0.id == coin.id })
        }
        return originalCoins + newSyncCoins + newSearchCoins
    }
    
    private func filterCoins(filterKey: String, coins: [CoinModel]) -> [CoinModel] {
        let filteredCoins = coins.filter {
            filterKey.isEmpty
            || $0.symbol.lowercased().contains(filterKey.lowercased())
            || $0.name.lowercased().contains(filterKey.lowercased())
        }
        
        return filteredCoins
    }
    
    private func sortCoins(sortOption: SortCoinOption, coins: [CoinModel]) -> [CoinModel] {
        return coins.sorted { coin1, coin2 in
            switch sortOption {
            case .rank, .holdings:
                return (coin1.marketCapRank ?? 99999) < (coin2.marketCapRank ?? 99999)
            case .rankReversed, .holdingsReversed:
                return (coin1.marketCapRank ?? 0 ) > (coin2.marketCapRank ?? 0)
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
