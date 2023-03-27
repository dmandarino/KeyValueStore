//
//  KVTransactionalInteractorMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 27/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

@testable import KeyValueStore

class KVTransactionalInteractorMock: KVTransactionalInteractable {
    
    var delegate: KVTransactionalInteractableDelegate?
    
    var setCallCount = 0
    var deleteCallCount = 0
    var getCallCount = 0
    var countCallCount = 0
    var commitCallCount = 0
    var beginCallCount = 0
    var rollbackCallCount = 0
    
    func set(key: String, value: String) {
        setCallCount += 1
    }
    
    func delete(key: String) {
        deleteCallCount += 1
    }
    
    func get(key: String) {
        getCallCount += 1
    }
    
    func count(value: String) {
        countCallCount += 1
    }
    
    func commit() {
        commitCallCount += 1
    }
    
    func begin() {
        beginCallCount += 1
    }
    
    func rollback() {
        rollbackCallCount += 1
    }
}
