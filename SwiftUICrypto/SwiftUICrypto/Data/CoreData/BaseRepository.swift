//
//  BaseRepository.swift
//  SwiftUICrypto
//

import CoreData

class BaseRepository {
    let container: NSPersistentContainer
    let containerName: String = "CryptoTrackerContainer"
    
    init(appGroupID: String) {
        container = NSPersistentContainer(name: containerName)
        let storeURL = URL.storeURL(for: appGroupID, databaseName: containerName)
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [storeDescription]

        container.loadPersistentStores { (_, error) in
            if let error = error {
                MyLogger.debugLog("BaseRepository init error: \(error)")
            }
        }
    }
}
