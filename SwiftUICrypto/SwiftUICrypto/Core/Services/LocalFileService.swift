//
//  LocalFileService.swift
//  SwiftUICrypto

import Foundation
import UIKit

struct LocalFileService {
    let cached = NSCache<NSString, UIImage>()
    private let baseUrl: URL?
    
    init(baseUrl: URL? = nil) {
        self.baseUrl = baseUrl ?? FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func saveImage(image: UIImage, imageName: String, folderName: String) async {
        await createFolderIfNotExist(folderName: folderName)
        
        guard
            let data = image.pngData(),
            let imageUrl = getImageUrl(folderName: folderName, imageName: imageName)
        else {
            MyLogger.debugLog("LocalFileService: saveImage: - Failed to get data or url")
            return
        }
        
        do {
            MyLogger.debugLog("LocalFileService: saveImage to url: \(imageUrl.path())")
            try data.write(to: imageUrl)
        } catch {
            MyLogger.debugLog("LocalFileService: saveImage - Failed to save image: \(error.localizedDescription)")
        }
        
    }
    
    func getImage(folderName: String, imageName: String) async -> UIImage? {
        let imageKey = "\(folderName)/\(imageName)" as NSString
        if let image = cached.object(forKey: imageKey) {
            MyLogger.debugLog("LocalFileService: getImage: \(imageKey) from cached")
            return image
        }
        
        guard
            let imageUrl = getImageUrl(folderName: folderName, imageName: imageName),
            FileManager.default.fileExists(atPath: imageUrl.path())
        else {
            MyLogger.debugLog("LocalFileService: getImage - Failed to get image url or file not exist")
            return nil
        }
        
       guard let image = UIImage(contentsOfFile: imageUrl.path()) else {
           return nil
        }
        
        MyLogger.debugLog("LocalFileService: getImage: \(imageKey) from storage")
        
        cached.setObject(image, forKey: imageKey)
        return image
    }
    
    private func createFolderIfNotExist(folderName: String) async {
        guard let folderUrl = getFolderUrl(folderName: folderName) else {
            MyLogger.debugLog("LocalFileService: createFolderIfNotExist - Folder url not found")
            return
        }
        if !FileManager.default.fileExists(atPath: folderUrl.path()) {
            MyLogger.debugLog("LocalFileService: createFolderIfNotExist - Folder not exist, creating...")
            MyLogger.debugLog("LocalFileService: createFolderIfNotExist - at path: \(folderUrl.path())")
            do {
                try FileManager.default.createDirectory(
                    at: folderUrl,
                    withIntermediateDirectories: true
                )
            } catch {
                MyLogger.debugLog("LocalFileService: createFolderIfNotExist - Failed to create folder: \(error.localizedDescription)")
            }
            
        } else {
            MyLogger.debugLog("LocalFileService: \(folderUrl.path()) existing")
        }
    }
    
    private func getImageUrl(folderName: String, imageName: String) -> URL? {
        guard let folderUrl = getFolderUrl(folderName: folderName) else {
            return nil
        }
        
        return folderUrl.appendingPathComponent(imageName + ".png")
    }
    
    private func getFolderUrl(folderName: String) -> URL? {
        guard let baseUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        
        return baseUrl.appendingPathComponent(folderName)
    }
    
}

extension LocalFileService {
    nonisolated(unsafe) static var sharedWithAppGroup: LocalFileService { .init( baseUrl: URL.sharedContainerURL(for: Constant.appGroupID)) }
}
