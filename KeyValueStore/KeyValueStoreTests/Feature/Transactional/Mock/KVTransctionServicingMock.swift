//
//  KVStoreServiceMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import KeyValueStore

//class KVTransactionServicingMock: KVTransactionServicing {
//    var shouldPass: Bool = true
//    var store: [String : String] = [:]
//    var error: KVStoreError? = .none
//    var successString = ""
//    var successInt = 0
//    
//    var setCallCount = 0
//    var deleteCallCount = 0
//    var getCallCount = 0
//    var countCallCount = 0
//    var getTransientTransactionCount = 0
//    var updateTransaction = 0
//    
//    func set(key: String, value: String) -> Result<Void, KVStoreError> {
//        setCallCount += 1
//        if shouldPass {
//            return .success(())
//        }
//        return .failure(.emptyKey)
//    }
//    
//    func delete(key: String) -> Result<Void, KVStoreError> {
//        deleteCallCount += 1
//        if shouldPass {
//            return .success(())
//        }
//        return .failure(error!)
//    }
//    
//    func get(key: String) -> Result<String, KVStoreError> {
//        getCallCount += 1
//        if shouldPass {
//            return .success(successString)
//        }
//        return .failure(.keyNotFound)
//    }
//    
//    func count(value: String) -> Result<Int, KVStoreError> {
//        countCallCount += 1
//        if shouldPass {
//            return .success(successInt)
//        }
//        return .failure(.emptyValue)
//    }
//    
//    func getTransientTransaction() -> [String : String] {
//        getTransientTransactionCount += 1
//        return store
//    }
//    
//    func updateTransaction(items: [String : String]) {
//        updateTransaction += 1
//    }
//}
