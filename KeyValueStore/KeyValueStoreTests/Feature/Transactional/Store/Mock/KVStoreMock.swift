//
//  KVStoreMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore

class KVStoreMock: KVStoring {
    
    var items: [String : String]
    
    var updateStoreCallCount = 0
    var getStoreCallCount = 0
    
    init(items: [String : String] = [:]) {
        self.items = items
    }
    
    func updateStore(with items: [String : String]) -> [String : String] {
        updateStoreCallCount += 1
        self.items = items
        return items
    }
    
    func getStore() -> [String : String] {
        getStoreCallCount += 1
        return items
    }
}
