//
//  BaseRepository.swift
//  SwiftUICrypto
//

import CoreData

class BaseRepository {
    let container: NSPersistentContainer
    let containerName: String = "CryptoTrackerContainer"
    
    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                MyLogger.debugLog("BaseRepository init error: \(error)")
            }
        }
    }
}
