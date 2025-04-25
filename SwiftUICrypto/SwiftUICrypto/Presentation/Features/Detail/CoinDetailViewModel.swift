//
//  CoinDetailViewModel.swift
//  SwiftUICrypto
//

import Foundation
import Combine

class CoinDetailViewModel: BaseViewModel {
    @Published var coin: CoinModel
    @Published var overviewStatistics: [StatisticModel] = []
    @Published var additionalStatistics: [StatisticModel] = []
    
    private var coinGeckoApi: CoinGeckoApiProtocol = CoinGeckoApi()
    
    init(coin: CoinModel) {
        self.coin = coin
    }
    
    func fetchCoinDetail() {
        coinGeckoApi.fetchCoinDetail(coinId: coin.id)
            .catch { [weak self] error -> Empty<CoinDetailModel, Never> in
                self?.error = error
                return Empty(completeImmediately: true)
            }
            .combineLatest($coin)
            .map { [weak self] (coinDetail, coin) -> (overviewsStatistics: [StatisticModel], additionalStatistics: [StatisticModel]) in
                guard let self else { return ([], []) }
                
                return (
                    overviewsStatistics: self.mapDataOverviewStatistics(coinDetail: coinDetail, coin: coin),
                    additionalStatistics: self.mapDataToAdditionalStatistics(coinDetail: coinDetail, coin: coin)
                )
            }
            .sink { [weak self] (data) in
                self?.overviewStatistics = data.overviewsStatistics
            }
            .store(in: &cancellables)
    }
    
    func mapDataToAdditionalStatistics(coinDetail: CoinDetailModel, coin: CoinModel) -> [StatisticModel] {
        let highStatistic = StatisticModel(
            title: "24H High",
            value: coin.high24h.valueOrZero().formattedWithAbbreviations()
        )
        
        let lowStatistic = StatisticModel(
            title: "24H Low",
            value: coin.low24h.valueOrZero().formattedWithAbbreviations()
        )
        
        let priceChangeStatistic = StatisticModel(
            title: "24H Price Change",
            value: coin.priceChange24h.valueOrZero().asPercentageString()
        )
        
        let marketCapChangeStatistic = StatisticModel(
            title: "24H Market Cap Change",
            value: coin.marketCapChange24h.valueOrZero().formattedWithAbbreviations(),
            percentageChange: coin.marketCapChangePercentage24h
        )
        
        let blockTimeStatistic = StatisticModel(
            title: "Block Time",
            value: "\(coinDetail.blockTimeInMinutes.valueOrZero())"
        )
        
        let hashingAlgorithmStatistic = StatisticModel(
            title: "Hashing Algorithm",
            value: coinDetail.hashingAlgorithm ?? "N/A"
        )
        
        return [
            highStatistic,
            lowStatistic,
            priceChangeStatistic,
            marketCapChangeStatistic,
            blockTimeStatistic,
            hashingAlgorithmStatistic
        ]
    }
    
    func mapDataOverviewStatistics(
        coinDetail: CoinDetailModel,
        coin: CoinModel
    ) -> [StatisticModel] {
        let priceStatistic = StatisticModel(
            title: "Current Price",
            value: coin.currentPrice.valueOrZero().formattedWithAbbreviations(),
            percentageChange: coin.priceChangePercentage24h
        )
        
        let marketCapStatistic = StatisticModel(
            title: "Market Capitalization",
            value: coin.marketCap.valueOrZero().asPercentageString(),
            percentageChange: coin.marketCapChangePercentage24h
        )
        
        let rankStatistic = StatisticModel(
            title: "Rank",
            value: "\(coin.marketCapRank)"
        )
        
        let volumeStatistic = StatisticModel(
            title: "Volume",
            value: coin.totalVolume.valueOrZero().formattedWithAbbreviations()
        )
        
        return [
            priceStatistic,
            marketCapStatistic,
            rankStatistic,
            volumeStatistic
        ]
    }
}
