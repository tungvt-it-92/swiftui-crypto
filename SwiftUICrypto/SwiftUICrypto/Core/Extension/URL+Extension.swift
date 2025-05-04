//
//  URL+Extension.swift
//  SwiftUICrypto
//
import Foundation

public extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        let sharedContainerURL = sharedContainerURL(for: appGroup)

        return sharedContainerURL.appendingPathComponent("\(databaseName).sqlite")
    }
    
    static func sharedContainerURL(for appGroup: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }
        
        return fileContainer
    }
}