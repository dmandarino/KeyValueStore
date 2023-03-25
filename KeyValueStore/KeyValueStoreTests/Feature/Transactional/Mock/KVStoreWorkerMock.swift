//
//  KVStoreWorkerMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 24/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore

class KVStoreWorkerMock: KVStoreWorkable {
    var shouldPass: Bool = true
    var store: [String: String] = [:]
    
    var updateStoreCallCount = 0
    var setCallCount = 0
    var deleteCallCount = 0
    var getCallCount = 0
    var getAllCallCount = 0
    
    func updateStore(with transactions: [String : String]) {
        updateStoreCallCount += 1
    }
    
    func set(key: String, value: String) {
        setCallCount += 1
        store[key] = value
    }
    
    func delete(key: String) -> Bool {
        deleteCallCount += 1
        return shouldPass
    }
    
    func get(key: String) -> String? {
        getCallCount += 1
        return shouldPass ? store[key] : nil
    }
    
    func getAll() -> [String : String] {
        getAllCallCount += 1
        return store
    }
}
