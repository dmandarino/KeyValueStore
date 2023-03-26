//
//  KVService.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

final class KVStoreService: KVStoreServicing {

    // MARK: - Private Variables
    
    private var kvStore: KVStoring
    
    // MARK: - Init
    
    init(store: KVStoring) {
        self.kvStore = store
    }
    
    // MARK: - KVStoreServicing
    
    func set(key: String, value: String) -> Result<Void, KVStoreError> {
        guard key.isNotEmpty else {
            return .failure(.emptyKey)
        }
        guard case let .success(data) = getAll() else {
            return .failure(.noStore)
        }
        var newStored = data
        newStored[key] = value
        return updateLocalStore(data: newStored)
    }
    
    func delete(key: String) -> Result<String, KVStoreError> {
        guard key.isNotEmpty else {
            return .failure(.emptyKey)
        }
        guard let value = kvStore.delete(by: key) else {
            return .failure(.keyNotFound)
        }
        return .success(value)
    }
    
    func get(key: String) -> Result<String, KVStoreError> {
        guard key.isNotEmpty else {
            return .failure(.emptyKey)
        }
        guard let value = kvStore.getValue(by: key) else {
            return .failure(.keyNotFound)
        }
        return .success(value)
    }
    
    func count(value: String) -> Result<Int, KVStoreError> {
        guard value.isNotEmpty else {
            return .failure(.emptyValue)
        }
        guard case let .success(data) = getAll() else {
            return .failure(.noStore)
        }
        let filtered = data.filter { $0.value == value }
        return .success(filtered.count)
    }
    
    func updateStore(items: [String : String]) -> Result<Void, KVStoreError> {
        guard case .success(_) = getAll() else {
            return .failure(.noStore)
        }
        return updateLocalStore(data: items)
    }
    
    func getAll() -> Result<[String : String], KVStoreError> {
        guard let stored = kvStore.getStore() else {
            return .failure(.noStore)
        }
        return .success(stored)
    }
    
    // MARK: - Private Methods
    
    private func updateLocalStore(data: [String: String]) -> Result<Void, KVStoreError> {
        self.kvStore.updateStore(with: data)
        return .success(())
    }
}
