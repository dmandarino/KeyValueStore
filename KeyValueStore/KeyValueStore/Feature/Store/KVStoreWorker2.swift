//
//  KVStoreService.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 24/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

/*
 KVTransactionServicing is responsible for accessing Store. We're assuming is in memory, but if it was another SDK or local Storage,
 it's unlikely that we change this protocol to protect our application.
 */
public protocol KVStoreWorkable {
    func updateStore(with transactions: [String: String])
    func set(key: String, value: String)
    func delete(key: String) -> Bool
    func get(key: String) -> String?
    func getAll() -> [String: String]
}

final class KVStoreWorker2: KVStoreWorkable {
    
    private var kvStore: KVStoring
    
    init(store: KVStoring) {
        self.kvStore = store
    }
    
    func updateStore(with transactions: [String : String]) {
        var stored = kvStore.getStore()
        stored.merge(transactions) { (_, new) in new }
        kvStore.updateStore(with: stored)
    }
    
    func set(key: String, value: String) {
        var stored = kvStore.getStore()
        stored[key] = value
        kvStore.updateStore(with: stored)
    }
    
    func delete(key: String) -> Bool {
        var stored = kvStore.getStore()
        if let _ = stored.removeValue(forKey: key) {
            kvStore.updateStore(with: stored)
            return true
        }
        return false
    }
    
    func get(key: String) -> String? {
        var stored = kvStore.getStore()
        return stored[key]
    }
    
    func getAll() -> [String : String] {
        kvStore.getStore()
    }
}
