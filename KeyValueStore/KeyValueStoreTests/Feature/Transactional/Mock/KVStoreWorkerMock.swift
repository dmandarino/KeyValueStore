//
//  KVStoreWorkerMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 24/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore

class KVStoreWorkerMock: KVStoreWorkable {
    var store: [String: String] = [:]
    var expectedStore: [String: String] = [:]
    var expectedValue = ""
    var shouldFail = false
    
    var updateStoreCallCount = 0
    var setCallCount = 0
    var deleteCallCount = 0
    var getCallCount = 0
    var getAllCallCount = 0
    var countCallCount = 0
    
    func updateStore(with transactions: [String : String]) {
        updateStoreCallCount += 1
        if !shouldFail {
            store = transactions
        }
    }
    
    func set(key: String, value: String) {
        setCallCount += 1
        if !shouldFail {
            store[key] = value
        }
    }
    
    func delete(by key: String) {
        deleteCallCount += 1
    }
    
    func get(by key: String) {
        getCallCount += 1
    }
    
    func getAll() {
        getAllCallCount += 1
    }
    
    func count(for value: String) {
        countCallCount += 1
    }
}
