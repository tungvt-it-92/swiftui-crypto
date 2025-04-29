//
//  NetworkImageService.swift
//  SwiftUICrypto

import UIKit
import Combine

extension AnyPublisher: @unchecked @retroactive Sendable where Output == UIImage?, Failure == Never {}

struct NetworkImageService: @unchecked Sendable {
    let coinImagesFolder = "coinImages"
    
    func downloadImageAsync(imageUrl: String) async -> UIImage? {
        let imageKey = imageUrl.sha256()
        if let cachedImage = await LocalFileService.shared.getImage(
            folderName: coinImagesFolder,
            imageName: imageKey
        ) {
            return cachedImage
        }
        
        guard let url = URL(string: imageUrl) else {
            return nil
        }
        
        do {
            let data = try await NetworkService()
                .execute(endpointUrl: url)
                .asyncValue()
            
            guard let image = UIImage(data: data) else {
                return nil
            }
            
            await LocalFileService.shared.saveImage(
                image: image,
                imageName: imageKey,
                folderName: self.coinImagesFolder
            )
            
            return image
        } catch {
            MyLogger.debugLog("Error downloading image: \(error)")
            return nil
        }
    }
    
    @available(*, deprecated, message: "Use downloadImageAsync(imageUrl:) instead.")
    func downloadImage(imageUrl: String) async -> AnyPublisher<UIImage?, Never> {
        let imageKey = imageUrl.sha256()
        if let cachedImage = await LocalFileService.shared.getImage(
            folderName: coinImagesFolder,
            imageName: imageKey
        ) {
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
                Task {
                    if let `image` = image {
                        await LocalFileService.shared.saveImage(
                            image: `image`,
                            imageName: imageKey,
                            folderName: self.coinImagesFolder
                        )
                    }
                }
            })
            .catch { error in
                MyLogger.debugLog("Error downloading image: \(error)")
                return Just<UIImage?>(nil)
            }
            .eraseToAnyPublisher()
    }
}

