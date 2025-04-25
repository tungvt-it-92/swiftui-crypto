//
//  CoinDetailModel.swift
//  SwiftUICrypto
//

struct CoinDetailModel: Codable {
    let id: String
    let symbol: String
    let name: String
    let description: Description
    let image: ImageInfo?
    let categories: [String]?
    let links: Link?
    let hashingAlgorithm: String?
    let blockTimeInMinutes: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, description, image, categories, links
        case hashingAlgorithm = "hashing_algorithm"
        case blockTimeInMinutes = "block_time_in_minutes"
    }
}

struct Description: Codable {
    let en: String?
}

struct ImageInfo: Codable {
    let large: String?
}

struct Link: Codable {
    let homepage: [String]?
    let subredditUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case homepage
        case subredditUrl = "subreddit_url"
    }
}
