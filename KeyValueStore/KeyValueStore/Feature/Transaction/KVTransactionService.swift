//
//  KVService.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

final class KVTransactionService: KVTransactionServicing {
    
    var kvStore: KVStoring
    
    init(store: KVStoring) {
        self.kvStore = store
    }
    
    func set(key: String, value: String) -> Result<Void, KVTransactionError> {
        guard key.isNotEmpty else {
            return .failure(.emptyKey)
        }
        kvStore.store[key] = value
        return .success(())
    }
    
    func get(key: String) -> Result<String, KVTransactionError> {
        if let value = kvStore.store[key] {
            return .success(value)
        }
        return .failure(.keyNotFound)
    }
    
    func delete(key: String) -> Result<Void, KVTransactionError> {
        guard key.isNotEmpty else {
            return .failure(.emptyKey)
        }
        guard kvStore.store.removeValue(forKey: key) != nil else {
            return .failure(.keyNotFound)
        }
        return .success(())
    }
    
    func count(value: String) -> Result<Int, KVTransactionError> {
        guard value.isNotEmpty else {
            return .failure(.emptyValue)
        }
        let filtered = kvStore.store.filter { $0.value == value }
        return .success(filtered.count)
    }
}
