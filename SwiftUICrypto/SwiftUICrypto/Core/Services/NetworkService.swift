//
//  NetworkService.swift
//  SwiftUICrypto
//

import Combine
import Foundation

enum APIError: LocalizedError {
    case urlInvalid
    case badResponse(url: URL)
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .urlInvalid:
            return "URL is invalid"
        case let .badResponse(url):
            return "Bad response from the server: \n \(url.absoluteString)"
        case .decodingFailed:
            return "Decoding failed"
        }
    }
}

struct NetworkService {
    func execute(
        endpointUrl: URL,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) -> AnyPublisher<Data, Error> {
        let request = URLRequest(url: endpointUrl, cachePolicy: cachePolicy)
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { output -> Data in
                guard let response = output.response as? HTTPURLResponse,
                      (200 ... 299).contains(response.statusCode) else {
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
            .receive(on: DispatchQueue.main)
        #if DEBUG
            .print()
        #endif
            .eraseToAnyPublisher()
    }
}
