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
    @Published var coinDescription: String? = nil
    @Published var homepageUrl: String? = nil
    @Published var redditUrl: String? = nil
    
    private var coinGeckoApi: CoinGeckoApiProtocol = CoinGeckoApi()
    
    init(coin: CoinModel) {
        self.coin = coin
    }
    
    func fetchCoinDetail() {
        coinGeckoApi
                .fetchCoinDetail(coinId: coin.id)
                .catch { [weak self] error -> AnyPublisher<CoinDetailModel, Never> in
                    self?.error = error
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                .map { [weak self] (coinDetail) -> (overviews: [StatisticModel], additional: [StatisticModel], description: String?, homepage: String?, reddit: String?) in
                    guard let self else { return ([], [], nil, nil, nil) }
                    return (
                        overviews: self.mapDataOverviewStatistics(coinDetail: coinDetail, coin: coin),
                        additional: self.mapDataToAdditionalStatistics(coinDetail: coinDetail, coin: coin),
                        description: coinDetail.description.en,
                        homepage: coinDetail.links?.homepage?.first,
                        reddit: coinDetail.links?.subredditUrl
                    )
                }
                .receive(on: DispatchQueue.main)
                .sink { [weak self] data in
                    self?.overviewStatistics = data.overviews
                    self?.additionalStatistics = data.additional
                    self?.coinDescription = data.description
                    self?.homepageUrl = data.homepage
                    self?.redditUrl = data.reddit
                }
                .store(in: &cancellables)
    }
    
    func mapDataToAdditionalStatistics(
        coinDetail: CoinDetailModel,
        coin: CoinModel
    ) -> [StatisticModel] {
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
            value: coin.marketCap.valueOrZero().formattedWithAbbreviations(),
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
