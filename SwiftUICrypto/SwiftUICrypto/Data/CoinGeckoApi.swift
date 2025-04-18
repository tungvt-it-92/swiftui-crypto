//
//  CoinGeckoApi.swift
//  SwiftUICrypto

import Combine
import Foundation

protocol CoinGeckoApiProtocol {
    func fetchCoins() -> AnyPublisher<[CoinModel], APIError>
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
            with: "coins/markets?vs_currency=usd&page=1&per_page=250&sparkline=true"
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

    private func buildEndpointUrl(with path: String) -> AnyPublisher<URL, APIError> {
        let urlString = "\(baseUrl)\(path)"
        guard let url = URL(string: urlString) else {
            return Fail(error: APIError.urlInvalid)
                .eraseToAnyPublisher()
        }

        return Just(url)
            .setFailureType(to: APIError.self)
            .eraseToAnyPublisher()
    }
}
