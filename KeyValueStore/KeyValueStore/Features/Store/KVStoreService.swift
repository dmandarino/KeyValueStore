//
//  KVService.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

/*
 KVStoreServicing is responsible for accessing Store. We're assuming is in memory, but if it was another SDK or local Storage,
 it's unlikely that we change this protocol to protect our application.
 */
public protocol KVStoreServicing {
    @discardableResult func set(key: String, value: String) -> Result<Void, KVStoreError>
    @discardableResult func delete(key: String) -> Result<Void, KVStoreError>
    func get(key: String) -> Result<String, KVStoreError>
    func count(value: String) -> Result<Int, KVStoreError>
}

final class KVStoreService: KVStoreServicing {
    
    var kvStore: KVStoring
    
    init(store: KVStoring) {
        self.kvStore = store
    }
    
    func set(key: String, value: String) -> Result<Void, KVStoreError> {
        guard key.isNotEmpty else {
            return .failure(.emptyKey)
        }
        kvStore.store[key] = value
        return .success(())
    }
    
    func get(key: String) -> Result<String, KVStoreError> {
        if let value = kvStore.store[key] {
            return .success(value)
        }
        return .failure(.keyNotFound)
    }
    
    func delete(key: String) -> Result<Void, KVStoreError> {
        guard key.isNotEmpty else {
            return .failure(.emptyKey)
        }
        guard kvStore.store.removeValue(forKey: key) != nil else {
            return .failure(.keyNotFound)
        }
        return .success(())
    }
    
    func count(value: String) -> Result<Int, KVStoreError> {
        guard value.isNotEmpty else {
            return .failure(.emptyValue)
        }
        let filtered = kvStore.store.filter { $0.value == value }
        return .success(filtered.count)
    }
}
