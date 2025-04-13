//
//  NetworkImageService.swift
//  SwiftUICrypto

import UIKit
import Combine

struct NetworkImageService {
    let coinImagesFolder = "coinImages"
    
    init () {
        
    }
    
    func downloadImage(imageUrl: String) -> AnyPublisher<UIImage?, Never> {
        let imageKey = imageUrl.sha256()
        
        if let cachedImage = LocalFileService.shared.getImage(folderName: coinImagesFolder, imageName: imageKey) {
            return Just(cachedImage)
                .eraseToAnyPublisher()
        }
        
        guard let url = URL(string: imageUrl) else {
            return Just(nil)
                .eraseToAnyPublisher()
        }
        
        return NetworkService()
            .execute(endpointUrl: url)
            .tryMap { (data) -> UIImage? in
                return UIImage(data: data)
            }
            .handleEvents(receiveOutput: { image in
                if let `image` = image {
                    LocalFileService.shared.saveImage(
                        image: `image`,
                        imageName: imageKey,
                        folderName: self.coinImagesFolder
                    )
                }
            })
            .catch { error in
                MyLogger.debugLog("Error downloading image: \(error)")
                return Just<UIImage?>(nil)
            }
            .eraseToAnyPublisher()
    }
}

