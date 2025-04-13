//
//  CoinGeckoApi.swift
//  SwiftUICrypto

import Foundation
import Combine

protocol CoinGeckoApiProtocol {
    func fetchCoins() -> AnyPublisher<[CoinModel], APIError>
}

struct CoinGeckoApi: CoinGeckoApiProtocol {
    private let baseUrl = "https://api.coingecko.com/api/v3/"
    private let jsonDecoder: JSONDecoder
    
    init() {
        self.jsonDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func fetchCoins() -> AnyPublisher<[CoinModel], APIError> {
        guard let endpointUrl = buildEndpointUrl(
            with: "coins/markets?vs_currency=usd&page=1&per_page=250&sparkline=true"
        ) else {
            return Fail(error: APIError.urlInvalid)
                .eraseToAnyPublisher()
        }
        
        return NetworkService().execute(endpointUrl: endpointUrl)
            .decode(type: [CoinModel].self, decoder: jsonDecoder)
            .mapError{ error in
                if let apiError = error as? APIError {
                    return apiError
                }
                
                if error is DecodingError {
                    return .decodingFailed(message: "Failed to decode CoinModel")
                }
                return .unknown
            }
            .map({ coins in
                return coins.map { coin in
                    var newCoin = coin
                    newCoin.favorite = Int.random(in: 1..<10) < 3
                    newCoin.currentHolding = Double.random(in: 100..<10000)
                    newCoin.currentHoldingValue = Double.random(in: 100..<1000)
                    
                    return newCoin
                }
            })
            .eraseToAnyPublisher()
    }
    
    private func buildEndpointUrl(with path: String) -> URL? {
        return URL(string: "\(baseUrl)\(path)")
    }
}
