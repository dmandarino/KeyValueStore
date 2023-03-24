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
    func delete(key: String)
    func get(key: String) -> String?
    func getAll() -> [String: String]
}

final class KVStoreWorker: KVStoreWorkable {
    
    private var kvStore: KVStoring
    
    init(store: KVStoring) {
        self.kvStore = store
    }
    
    func updateStore(with transactions: [String : String]) {
        kvStore.store.merge(transactions) { (_, new) in new }
    }
    
    func set(key: String, value: String) {
        kvStore.store[key] = value
    }
    
    func delete(key: String) {
        kvStore.store.removeValue(forKey: key)
    }
    
    func get(key: String) -> String? {
        kvStore.store[key]
    }
    
    func getAll() -> [String : String] {
        kvStore.store
    }
}
