//
//  CoinImageViewModel.swift
//  SwiftUICrypto
//

import Foundation
import UIKit
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage?
    @Published var isFetchingImage: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    private var networkImageService: NetworkImageService
    
    init() {
        networkImageService = NetworkImageService();
    }
    
    func fetchImage(imageUrl: String) {
        isFetchingImage = true
        networkImageService.downloadImage(imageUrl: imageUrl)
            .sink { [weak self] completion in
                self?.isFetchingImage = false
            } receiveValue: { [weak self] image in
                self?.image = image
            }
            .store(in: &cancellables)
        
    }   
}
