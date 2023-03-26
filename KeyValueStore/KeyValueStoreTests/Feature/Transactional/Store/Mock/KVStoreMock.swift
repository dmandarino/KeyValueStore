//
//  KVStoreMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore

class KVStoreMock: KVStoring {
    
    var items: [String : String]? = nil
    var valueExpected: String? = nil
    var deleteExpected: String? = nil
    var shouldFail = false
    
    var updateStoreCallCount = 0
    var getStoreCallCount = 0
    var getValueCallCount = 0
    var deleteCallCount = 0
    
    init(items: [String : String] = [:]) {
        self.items = items
    }
    
    func updateStore(with items: [String : String]) -> [String : String] {
        updateStoreCallCount += 1
        self.items = items
        return shouldFail ? [:] : items
    }
    
    func getStore() -> [String : String]? {
        getStoreCallCount += 1
        return shouldFail ? nil : items
    }
    
    func getValue(by key: String) -> String? {
        getValueCallCount += 1
        return shouldFail ? nil : valueExpected
    }
    
    func delete(by key: String) -> String? {
        deleteCallCount += 1
        return shouldFail ? nil : deleteExpected
    }
}
