//
//  CoinGeckoApi.swift
//  SwiftUICrypto
//

import Foundation
import Combine

enum APIError: LocalizedError {
    case urlInvalid
    case badResponse(url: URL)
    case decodingFailed
    
    var errorDescription: String? {
        switch self {
        case .urlInvalid:
            return "URL is invalid"
        case .badResponse(let url):
            return "Bad response from the server: \n \(url.absoluteString)"
        case .decodingFailed:
            return "Decoding failed"
        }
    }
}

protocol CoinGeckoApiProtocol {
    func fetchCoins() -> AnyPublisher<[CoinModel], Error>
}
