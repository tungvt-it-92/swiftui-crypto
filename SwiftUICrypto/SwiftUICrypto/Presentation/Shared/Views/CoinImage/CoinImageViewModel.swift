//
//  CoinImageViewModel.swift
//  SwiftUICrypto
//

import Foundation
import UIKit
import Combine

@MainActor
class CoinImageViewModel: ObservableObject, @unchecked Sendable {
    @Published var image: UIImage?
    @Published var isFetchingImage: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private var networkImageService: NetworkImageService
    
    init(coin: CoinModel) {
        networkImageService = NetworkImageService()
        Task {
            if let imageUrlString = coin.image {
                await fetchImage(imageUrl: imageUrlString)
            }
        }
    }
    
    func fetchImage(imageUrl: String) async {
        isFetchingImage = true
        image = await networkImageService
            .downloadImageAsync(imageUrl: imageUrl)
        isFetchingImage = false
    }
}
