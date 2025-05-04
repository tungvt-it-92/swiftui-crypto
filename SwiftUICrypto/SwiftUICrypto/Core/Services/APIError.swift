//
//  APIError.swift
//  SwiftUICrypto
//
import Foundation

enum APIError: LocalizedError {
    case urlInvalid
    case badResponse(url: URL?)
    case decodingFailed(message: String)
    case noInternetConnection
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .urlInvalid:
            return "URL is invalid"
        case let .badResponse(url):
            return "Bad response from the server: \n \(url?.absoluteString ?? "Unknown URL")"
        case let .decodingFailed(msg):
            return "Decoding failed \(msg)"
        case .noInternetConnection:
            return "⚠️\nNo internet connection!!!\n Please check your internet settings and try again later."
        case .unknown:
            return "⚠️\nUnknown error!!!\n.Please try again later"
        }
    }
}
