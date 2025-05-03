//
//  CoinGeckoApi.swift
//  SwiftUICrypto

import Combine
import Foundation

protocol CoinGeckoApiProtocol {
    func fetchCoins(page: Int) -> AnyPublisher<[CoinModel], APIError>
    func fetchMarketData() -> AnyPublisher<MarketDataModel, APIError>
    func fetchCoinDetail(coinId: String) -> AnyPublisher<CoinDetailModel, APIError>
}

enum CoinGeckoApiEndpoint: NetworkUrlConvertible {
    case coinList(page: Int = 1)
    case marketData
    case coinDetail(coinId: String)
    
    func asURLRequest() ->URLRequest? {
        
        guard let url = buildUrl() else {
            return nil
        }
        
        var request  = URLRequest(url: url)
        for (key, value) in header {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    private var header: [String : String] {
        [
            "Content-Type": "application/json",
            "x-cg-demo-api-key": CoinGeckoApiConfigurationManager.apiKey
        ]
    }
    
    private func buildUrl() -> URL? {
        let urlString = "\(CoinGeckoApiConfigurationManager.baseUrl)\(path)"
        guard var uRLComponents = URLComponents(string: urlString) else {
            return nil
        }
        
        if let queryItems = queryItems {
            uRLComponents.queryItems = []
            queryItems.forEach { key, value in
                uRLComponents.queryItems!.append(URLQueryItem(name: key, value: "\(value)"))
            }
        }
        
        guard let url = uRLComponents.url else {
            return nil
        }
        
        return url
    }
    
    private var path: String {
        switch self {
        case .coinList:
            return "coins/markets"
        case .marketData:
            return "global"
        case .coinDetail(coinId: let id):
            return "coins/\(id)"
        }
    }
    
    private var queryItems: [String: Any]? {
        switch self {
        case .coinList(let page):
            return [
                "vs_currency": "usd",
                "page": page,
                "per_page": 250,
                "sparkline": true
            ]
        case .coinDetail:
            return [
                "localization": false,
                "tickers": false,
                "market_data": false,
                "community_data": false,
                "developer_data": false,
                "sparkline": false
            ]
        default: return nil
        }
    }
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
    
    func fetchCoins(page: Int = 1) -> AnyPublisher<[CoinModel], APIError> {
        return NetworkService()
            .execute(
                endpointUrl: CoinGeckoApiEndpoint.coinList(page: page),
                jsonDecoder: jsonDecoder
            )
    }
    
    func fetchMarketData() -> AnyPublisher<MarketDataModel, APIError> {
        return NetworkService()
            .execute(
                endpointUrl: CoinGeckoApiEndpoint.marketData,
                jsonDecoder: jsonDecoder
            )
            .eraseToAnyPublisher()
    }
    
    func fetchCoinDetail(coinId: String) -> AnyPublisher<CoinDetailModel, APIError> {
        return NetworkService()
            .execute(
                endpointUrl: CoinGeckoApiEndpoint.coinDetail(coinId: coinId),
                jsonDecoder: jsonDecoder
            )
            .eraseToAnyPublisher()
    }
}
