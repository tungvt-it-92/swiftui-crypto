//
//  CoinGeckoApi.swift
//  SwiftUICrypto

import Combine
import Foundation

protocol CoinGeckoApiProtocol {
    func fetchCoins() -> AnyPublisher<[CoinModel], APIError>
    func fetchMarketData() -> AnyPublisher<MarketDataModel, APIError>
    func fetchCoinDetail(coinId: String) -> AnyPublisher<CoinDetailModel, APIError>
}

struct CoinGeckoApi: CoinGeckoApiProtocol {
    private let baseUrl = "https://api.coingecko.com/api/v3/"
    private let jsonDecoder: JSONDecoder
    
    init() {
        jsonDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func fetchCoins() -> AnyPublisher<[CoinModel], APIError> {
       
        buildEndpointUrl(
            with: "coins/markets",
            queryItems: [
                "vs_currency": "usd",
                "page": 1,
                "per_page": 250,
                "sparkline": true
            ]
        )
        .flatMap { endpointUrl in
            NetworkService()
                .execute(
                    endpointUrl: endpointUrl,
                    jsonDecoder: jsonDecoder
                )
        }
        .eraseToAnyPublisher()
    }
    
    func fetchMarketData() -> AnyPublisher<MarketDataModel, APIError> {
        buildEndpointUrl(with: "global")
            .flatMap { url in
                NetworkService()
                    .execute(
                        endpointUrl: url,
                        jsonDecoder: jsonDecoder
                    )
            }
            .eraseToAnyPublisher()
    }
    
    func fetchCoinDetail(coinId: String) -> AnyPublisher<CoinDetailModel, APIError> {
        buildEndpointUrl(
            with: "coins/\(coinId)",
            queryItems: [
                "localization": false,
                "tickers": false,
                "market_data": false,
                "community_data": false,
                "developer_data": false,
                "sparkline": false
            ]
        )
        .flatMap { url in
            NetworkService()
                .execute(
                    endpointUrl: url,
                    jsonDecoder: jsonDecoder
                )
        }
        .eraseToAnyPublisher()
    }
    
    private func buildEndpointUrl(
        with path: String,
        queryItems: [String: Any]? = nil
    ) -> AnyPublisher<URL, APIError> {
        let urlString = "\(baseUrl)\(path)"
        guard var uRLComponents = URLComponents(string: urlString) else {
            return Fail(error: APIError.urlInvalid)
                .eraseToAnyPublisher()
        }
        
        if let queryItems = queryItems {
            uRLComponents.queryItems = []
            queryItems.forEach { key, value in
                uRLComponents.queryItems!.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }
        
        guard let url = uRLComponents.url else {
            return Fail(error: APIError.urlInvalid)
                .eraseToAnyPublisher()
        }
        
        return Just(url)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}
