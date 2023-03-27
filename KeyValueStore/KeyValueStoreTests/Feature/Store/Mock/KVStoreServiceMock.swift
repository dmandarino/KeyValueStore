//
//  KVStoreServiceMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 26/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore

final class KVStoreServiceMock: KVStoreServicing {
    
    var items: [String: String] = [:]
    var shouldFail = false
    var error: KVStoreError? = .none
    var expectedCount = 0
    var expectedValue = ""
    
    var setCallCount = 0
    var deleteCallCount = 0
    var getCallCount = 0
    var countCallCount = 0
    var updateStoreCallCount = 0
    var getAllCallCount = 0
    
    func set(key: String, value: String) -> Result<Void, KeyValueStore.KVStoreError> {
        setCallCount += 1
        self.items = [key: value]
        return shouldFail ? .failure(error!) : .success(())
    }
    
    func delete(key: String) -> Result<String, KeyValueStore.KVStoreError> {
        deleteCallCount += 1
        return shouldFail ? .failure(error!) : .success(expectedValue)
    }
    
    func get(key: String) -> Result<String, KeyValueStore.KVStoreError> {
        getCallCount += 1
        return shouldFail ? .failure(error!) : .success(expectedValue)
    }
    
    func count(value: String) -> Result<Int, KeyValueStore.KVStoreError> {
        countCallCount += 1
        return shouldFail ? .failure(error!) : .success(expectedCount)
    }
    
    func updateStore(items: [String : String]) -> Result<Void, KeyValueStore.KVStoreError> {
        updateStoreCallCount += 1
        self.items = items
        return shouldFail ? .failure(error!) : .success(())
    }
    
    func getAll() -> Result<[String : String], KeyValueStore.KVStoreError> {
        getAllCallCount += 1
        return shouldFail ? .failure(error!) : .success(items)
    }
}
