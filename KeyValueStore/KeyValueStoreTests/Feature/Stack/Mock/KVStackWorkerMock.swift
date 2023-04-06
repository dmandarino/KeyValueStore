//
//  KVStackServiceMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore

class KVStackWorkerMock: KVStackWorkable {
    var shouldFail: Bool = false
    var error: TransactionErrorReason? = .none
    var key: String = ""
    var oldValue: String? = nil
    var transactions: [KVTransactionModel] = []
    var transaction: KVTransactionModel?
    
    var beginCallCount = 0
    var commitCallCount = 0
    var rollbackCallCount = 0
    var clearAllCallCount = 0
    var addCommandCallCount = 0
    
    func clearAll() {
        clearAllCallCount += 1
    }
    
    func addCommand(key: String, oldValue: String?) {
        addCommandCallCount += 1
        self.key = key
        self.oldValue = oldValue
    }
    
    func begin() {
        beginCallCount += 1
    }
    
    func commit() -> Result<Void, KeyValueStore.TransactionErrorReason> {
        commitCallCount += 1
        return shouldFail ? .failure(error!) : .success(())
    }
    
    func rollback() -> Result<KeyValueStore.KVTransactionModel?, KeyValueStore.TransactionErrorReason> {
        rollbackCallCount += 1
        return shouldFail ? .failure(error!) : .success(transaction)
    }
}
