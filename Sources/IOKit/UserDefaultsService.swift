//
//  UserDefaultsService.swift
//
//  Created by Alper Ozturk on 13.6.22..
//

import Foundation

final public class UserDefaultsService {
    public let storage = UserDefaults.standard
    
    public init() {
        
    }
    
    public func write(_ key: String, data: Any) {
        storage.set(data, forKey: key)
    }
    
    public func readString(_ key: String) -> String? {
        storage.string(forKey: key)
    }
    
    public func readBool(_ key: String) -> Bool? {
        storage.bool(forKey: key)
    }
    
    public func readData(_ key: String) -> Data? {
        storage.data(forKey: key)
    }
    
    public func deleteAll() {
        if let appDomain = Bundle.main.bundleIdentifier {
            storage.removePersistentDomain(forName: appDomain)
        }
    }
}
