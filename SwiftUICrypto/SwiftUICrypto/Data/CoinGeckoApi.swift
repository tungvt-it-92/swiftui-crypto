//
//  CoinGeckoApi.swift
//  SwiftUICrypto

import Combine
import Foundation

protocol CoinGeckoApiProtocol {
    func fetchCoins(ids: [String]?) -> AnyPublisher<[CoinModel], APIError>
    func fetchMarketData() -> AnyPublisher<MarketDataModel, APIError>
    func fetchCoinDetail(coinId: String) -> AnyPublisher<CoinDetailModel, APIError>
    func searchCoin(query: String) -> AnyPublisher<[CoinModel], APIError>
}

enum CoinGeckoApiEndpoint: NetworkUrlConvertible {
    case coinList(ids: [String]? = nil)
    case marketData
    case coinDetail(coinId: String)
    case searchCoin(queryString: String)
    
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
        case .searchCoin(queryString: let query):
            return "search?query=\(query)"
        }
    }
    
    private var queryItems: [String: Any]? {
        switch self {
        case .coinList(let ids):
            var params: [String: Any] = [
                "vs_currency": "usd",
                "page": 1,
                "per_page": 100,
                "sparkline": true
            ]
            
            if let ids = ids, !ids.isEmpty {
                params["ids"] = ids.joined(separator: ",")
            }
            
            return params
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
    
    func fetchCoins(ids: [String]? = nil) -> AnyPublisher<[CoinModel], APIError> {
        Just([])
            .flatMap { _  -> AnyPublisher<[CoinModel], APIError> in
                return NetworkService()
                    .execute(
                        endpointUrl: CoinGeckoApiEndpoint.coinList(
                            ids: ids
                        ),
                        jsonDecoder: jsonDecoder
                    )
            }
            .eraseToAnyPublisher()
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
    
    func searchCoin(query: String) -> AnyPublisher<[CoinModel], APIError> {
        let searchPublisher: AnyPublisher<SearchResultEntity, APIError> = NetworkService()
            .execute(
                endpointUrl: CoinGeckoApiEndpoint.searchCoin(queryString: query),
                jsonDecoder: jsonDecoder
            )
        return searchPublisher.flatMap { (searchResultEntity) -> AnyPublisher<[CoinModel], APIError> in
            if searchResultEntity.coins.isEmpty {
                return Just([])
                    .setFailureType(to: APIError.self)
                    .eraseToAnyPublisher()
            }
            
            let ids = searchResultEntity.coins.map { $0.id }
            return NetworkService().execute(
                endpointUrl: CoinGeckoApiEndpoint.coinList(ids: ids),
                jsonDecoder: jsonDecoder
            )
        }
        .eraseToAnyPublisher()
    }
}
