//
//  NetworkService.swift
//  SwiftUICrypto
//

import Combine
import Foundation

enum APIError: LocalizedError {
    case urlInvalid
    case badResponse(url: URL)
    case decodingFailed(message: String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .urlInvalid:
            return "URL is invalid"
        case let .badResponse(url):
            return "Bad response from the server: \n \(url.absoluteString)"
        case .decodingFailed(let msg):
            return "Decoding failed \(msg)"
        case .unknown:
            return "Unknown error"
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
                    Endpoint: \(endpointUrl.absoluteString):
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
    
    func execute<T>(
        endpointUrl: URL,
        type: T.Type,
        jsonDecoder: JSONDecoder = JSONDecoder(),
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) -> AnyPublisher<T, APIError> where T: Decodable {
        return execute(endpointUrl: endpointUrl, cachePolicy: cachePolicy)
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError { error in
                if let apiError = error as? APIError {
                    return apiError
                }
                
                if error is DecodingError {
                    return .decodingFailed(message: "Failed to decode \(T.Type.self)")
                }
                return .unknown
            }
            .eraseToAnyPublisher()
    }
}
