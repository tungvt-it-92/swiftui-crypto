//
//  CoinGeckoApi.swift
//  SwiftUICrypto

import Foundation
import Combine

struct CoinGeckoApi: CoinGeckoApiProtocol {
    private let baseUrl = "https://api.coingecko.com/api/v3/"
    private let jsonDecoder: JSONDecoder
    
    init() {
        self.jsonDecoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func fetchCoins() -> AnyPublisher<[CoinModel], Error> {
        guard let endpointUrl = buildEndpointUrl(
            with: "coins/markets?vs_currency=usd&page=1&per_page=250&sparkline=true"
        ) else {
            return Fail(error: APIError.urlInvalid)
                .eraseToAnyPublisher()
        }
        
        return execute(endpointUrl: endpointUrl)
    }
    
    private func buildEndpointUrl(with path: String) -> URL? {
        return URL(string: "\(baseUrl)\(path)")
    }
    
    private func execute<T>(endpointUrl: URL) -> AnyPublisher<T, Error> where T : Decodable {
        let request = URLRequest(url: endpointUrl, cachePolicy: .returnCacheDataElseLoad)
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    throw APIError.badResponse(url: endpointUrl)
                }
                MyLogger.debugLog(
                                  """
                                  Endpoint \(endpointUrl.absoluteString):
                                  Response: \(String(describing: String(data: output.data, encoding: .utf8)))
                                  """
                )
                
                return output.data
            }
            .decode(type: T.self, decoder: jsonDecoder)
            .receive(on: DispatchQueue.main)
#if DEBUG
            .print()
#endif
            .eraseToAnyPublisher()
    }
}
