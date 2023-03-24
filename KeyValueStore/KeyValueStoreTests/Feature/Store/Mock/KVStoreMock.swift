//
//  KVStoreMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore

class KVStoreMock: KVStoring {
    var store: [String : String]
    
    init(store: [String : String] = [:]) {
        self.store = store
    }
}