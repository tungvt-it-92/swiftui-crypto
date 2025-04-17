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
        case let .decodingFailed(msg):
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

    func execute<T: Decodable>(
        endpointUrl: URL,
        jsonDecoder: JSONDecoder = JSONDecoder(),
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) -> AnyPublisher<T, APIError> {
        return execute(endpointUrl: endpointUrl, cachePolicy: cachePolicy)
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError { error in
                switch error {
                case let apiError as APIError:
                    return apiError
                case is DecodingError:
                    return .decodingFailed(
                        message: "Failed to decode response of type \(String(describing: T.self))"
                    )
                default:
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
    }
}
