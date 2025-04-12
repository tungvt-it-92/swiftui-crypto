//
//  Untitled.swift
//  SwiftUICrypto
//

import Foundation

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    
    func fetchCoins() async {
        allCoins.append(previewCoin)
        allCoins.append(previewCoin)
        allCoins.append(previewCoin)
        allCoins.append(previewCoin)
        allCoins.append(previewCoin)
        allCoins.append(previewCoin)
        allCoins.append(previewCoin)
        allCoins.append(previewCoin)
        allCoins.append(previewCoin)
        allCoins.append(previewCoin)
    }
}
