//
//  FileManagerService.swift
//  
//
//  Created by Alper Ozturk on 16.3.23..
//

import Foundation

public struct FileManagerService {
    private let manager = FileManager.default
    
    public init() {
        
    }
    
    public func createDirectoryIfNotExistAndGetPath(directoryName: String) throws -> String {
        let rootURL = try manager.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
        
        let directoryURL = rootURL.appendingPathComponent(directoryName)
        
        if !isDirectoryExist(directoryURL) {
            try createDirectory(directoryURL)
        }
        
        return directoryURL.path
    }
    
    public func createDirectory(_ url: URL) throws {
        try manager.createDirectory( at: url, withIntermediateDirectories: false, attributes: nil)
    }
    
    public func isDirectoryExist(_ url: URL) -> Bool {
        return manager.fileExists(atPath: url.relativePath)
    }
}
