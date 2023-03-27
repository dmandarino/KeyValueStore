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
    
    var updateStoreCallCount = 0
    var setCallCount = 0
    var deleteCallCount = 0
    var findCallCount = 0
    var findAllElementsCallCount = 0
    
    func updateStore(with transactions: [String : String]) {
        updateStoreCallCount += 1
    }
    
    func set(key: String, value: String) {
        setCallCount += 1
    }
    
    func delete(by key: String) {
        deleteCallCount += 1
    }
    
    func get(by key: String) {
        findCallCount += 1
    }
    
    func getAll() {
        findAllElementsCallCount += 1
    }
}
