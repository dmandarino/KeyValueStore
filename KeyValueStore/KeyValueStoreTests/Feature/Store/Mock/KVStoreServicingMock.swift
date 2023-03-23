//
//  KVStoreServiceMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import KeyValueStore

class KVStoreServicingMock: KVStoreServicing {
    var shouldPass: Bool = false
    var error: KVStoreError? = .none
    var successString = ""
    var successInt = 0
    
    var setCallCount = 0
    var deleteCallCount = 0
    var getCallCount = 0
    var countCallCount = 0
    
    func set(key: String, value: String) -> Result<Void, KVStoreError> {
        setCallCount += 1
        if shouldPass {
            return .success(())
        }
        return .failure(.emptyKey)
    }
    
    func delete(key: String) -> Result<Void, KVStoreError> {
        deleteCallCount += 1
        if shouldPass {
            return .success(())
        }
        return .failure(.keyNotFound)
    }
    
    func get(key: String) -> Result<String, KVStoreError> {
        getCallCount += 1
        if shouldPass {
            return .success(successString)
        }
        return .failure(.keyNotFound)
    }
    
    func count(value: String) -> Result<Int, KVStoreError> {
        countCallCount += 1
        if shouldPass {
            return .success(successInt)
        }
        return .failure(.emptyValue)
    }
}
