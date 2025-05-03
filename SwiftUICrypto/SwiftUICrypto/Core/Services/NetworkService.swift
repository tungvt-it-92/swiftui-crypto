//
//  NetworkService.swift
//  SwiftUICrypto
//

import Combine
import Foundation

protocol NetworkUrlConvertible {
    func asURLRequest() -> URLRequest?
}

enum APIError: LocalizedError {
    case urlInvalid
    case badResponse(url: URL?)
    case decodingFailed(message: String)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .urlInvalid:
            return "URL is invalid"
        case let .badResponse(url):
            return "Bad response from the server: \n \(url?.absoluteString ?? "Unknown URL")"
        case let .decodingFailed(msg):
            return "Decoding failed \(msg)"
        case .unknown:
            return "Unknown error"
        }
    }
}

struct NetworkService {
    func executeWithUrlConvertible(endpoint: NetworkUrlConvertible) -> AnyPublisher<Data, Error> {
        guard let request = endpoint.asURLRequest() else {
            return Fail(error: APIError.urlInvalid).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { output -> Data in
                return try tryMap(output: output, endpointUrl: request.url!)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func execute(
        endpointUrl: URL,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) -> AnyPublisher<Data, Error> {
        let request = URLRequest(url: endpointUrl, cachePolicy: cachePolicy)
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .tryMap { output -> Data in
                return try tryMap(output: output, endpointUrl: endpointUrl)
            }
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
            .subscribe(on: DispatchQueue.global(qos: .default))
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError(mapError)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func execute<T: Decodable>(
        endpointUrl: NetworkUrlConvertible,
        jsonDecoder: JSONDecoder = JSONDecoder()
    ) -> AnyPublisher<T, APIError> {
        return executeWithUrlConvertible(endpoint: endpointUrl)
            .subscribe(on: DispatchQueue.global(qos: .default))
            .decode(type: T.self, decoder: jsonDecoder)
            .mapError(mapError)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func tryMap(output: URLSession.DataTaskPublisher.Output, endpointUrl: URL) throws -> Data {
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
    
    private func mapError(error: Error) -> APIError {
        switch error {
        case let apiError as APIError:
            return apiError
        case let decodeError as DecodingError:
            var errorMsg = ""
            switch decodeError {
            case .valueNotFound(_, let context):
                errorMsg = "DecodingError valueNotFound  \(context.debugDescription) \(context.codingPath) \(String(describing: context.underlyingError))"
            case .typeMismatch(_, let context):
                errorMsg = "DecodingError typeMismatch \(context.debugDescription) \(context.codingPath) \(String(describing: context.underlyingError))"
            case .keyNotFound(_, let context):
                errorMsg = "DecodingError keyNotFound \(context.debugDescription) \(context.codingPath) \(String(describing: context.underlyingError))"
            case .dataCorrupted(let context):
                errorMsg = "DecodingError dataCorrupted  \(context.debugDescription) \(context.codingPath) \(String(describing: context.underlyingError))"
            default:
                errorMsg = decodeError.localizedDescription
            }
            
            return .decodingFailed(
                message: "Failed to decode api response with error: \(errorMsg)"
            )
        default:
            return .unknown
        }
    }
}
