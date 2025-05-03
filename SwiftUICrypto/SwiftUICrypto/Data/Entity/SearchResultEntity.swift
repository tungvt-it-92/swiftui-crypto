//
//  SearchResultEntity.swift
//  SwiftUICrypto
//

struct SearchResultEntity: Codable {
    struct CoinEntity: Codable {
        let id: String
        let name: String
        let symbol: String
    }
    
    let coins: [CoinEntity]
}