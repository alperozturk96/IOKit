//
//  KeychainService.swift
//
//  Created by Alper Ozturk on 13.6.22..
//

import Foundation

final public class KeychainService {
    
    private let target: String
    
    public init(target: String) {
        self.target = target
    }
    
    public func save(_ data: Data, key: String, updateExistingKey: Bool = true) {
        let query = [
            kSecValueData: data,
            kSecAttrService: key,
            kSecAttrAccount: target,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            // Item already exist, thus update it.
            let query = [
                kSecAttrService: key,
                kSecAttrAccount: target,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            if updateExistingKey {
                // Update existing item
                SecItemUpdate(query, attributesToUpdate)
            }
        }
    }
    
    public func read(_ key: String) -> Data? {
        let query = [
            kSecAttrService: key,
            kSecAttrAccount: target,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    public func delete(key: String) {
        
        let query = [
            kSecAttrService: key,
            kSecAttrAccount: target,
            kSecClass: kSecClassGenericPassword,
        ] as CFDictionary
        
        // Delete item from keychain
        SecItemDelete(query)
    }
    
    public func deleteAll() {
        let secItemClasses = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        for itemClass in secItemClasses {
            let spec: NSDictionary = [kSecClass: itemClass]
            SecItemDelete(spec)
        }
    }
}

public extension KeychainService {
    
    func saveCodableSource<T>(_ item: T, key: String) where T: Codable {
        do {
            // Encode as JSON data and save in keychain
            let data = try JSONEncoder().encode(item)
            save(data, key: key)
            
        } catch {
            print("KeychainService.saveCodableSource(): " + error.localizedDescription)
            assertionFailure("Fail to encode item for keychain: \(error)")
        }
    }
    
    func readCodableSource<T>(key: String, type: T.Type) -> T? where T: Codable {
        
        // Read item data from keychain
        guard let data = read(key) else {
            print("KeychainService.readCodableSource(): data is nil")
            return nil
        }
        
        // Decode JSON data to object
        do {
            let item = try JSONDecoder().decode(type, from: data)
            return item
        } catch {
            print("KeychainService.readCodableSource(): catch")
            assertionFailure("Fail to decode item for keychain: \(error)")
            return nil
        }
    }
}
