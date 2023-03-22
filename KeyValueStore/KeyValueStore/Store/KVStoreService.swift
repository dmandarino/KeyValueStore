//
//  KVService.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

public protocol KVStoreServicing {
    func set(key: String, value: String)
    func get(key: String) -> String?
}

final class KVStoreService: KVStoreServicing {
    
    var kvStore: KVStoring
    
    init(store: KVStoring) {
        self.kvStore = store
    }
    
    func set(key: String, value: String) {
        kvStore.store[key] = value
    }
    
    func get(key: String) -> String? {
        return kvStore.store[key]
    }
}
