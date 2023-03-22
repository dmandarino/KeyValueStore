//
//  KVService.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

public protocol KVStoreServicing {
    @discardableResult func set(key: String, value: String) -> Result<Void, KVStoreError>
    func get(key: String) -> Result<String, KVStoreError>
}

final class KVStoreService: KVStoreServicing {
    
    var kvStore: KVStoring
    
    init(store: KVStoring) {
        self.kvStore = store
    }
    
    @discardableResult func set(key: String, value: String) -> Result<Void, KVStoreError> {
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
}
