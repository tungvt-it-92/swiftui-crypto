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
    
    init() {
        networkImageService = NetworkImageService();
    }
    
    func fetchImage(imageUrl: String) async {
        isFetchingImage = true
        image = await networkImageService
            .downloadImageAsync(imageUrl: imageUrl)
        isFetchingImage = false
    }
}
