//
//  KVService.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

final class KVTransactionService: KVTransactionServicing {

    private var worker: KVStoreWorkable
    
    init(worker: KVStoreWorkable) {
        self.worker = worker
    }

    func set(key: String, value: String) -> Result<Void, KVTransactionError> {
        guard key.isNotEmpty else {
            return .failure(.emptyKey)
        }
        worker.set(key: key, value: value)
        return .success(())
    }
    
    func delete(key: String) -> Result<Void, KVTransactionError> {
        guard key.isNotEmpty else {
            return .failure(.emptyKey)
        }
        let didDelete = worker.delete(key: key)
        return didDelete ? .success(()) : .failure(.keyNotFound)
    }
    
    func get(key: String) -> Result<String, KVTransactionError> {
        guard key.isNotEmpty else {
            return .failure(.emptyKey)
        }
        guard let value = worker.get(key: key) else {
            return .failure(.keyNotFound)
        }
        return .success(value)
    }
    
    func count(value: String) -> Result<Int, KVTransactionError> {
        guard value.isNotEmpty else {
            return .failure(.emptyValue)
        }
        let store = worker.getAll()
        let filtered = store.filter { $0.value == value }
        return .success(filtered.count)
    }
    
    func updateTransaction(items: [String : String]) {
        let transaction = worker.getAll()
        worker.updateStore(with: items)
    }
    
    func getTransientTransaction() -> [String : String] {
        worker.getAll()
    }
}
