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
    var successString = ""
    var successInt = 0
    var transactions: [KVTransaction] = []
    var transaction: KVTransaction?
    
    var beginCallCount = 0
    var commitCallCount = 0
    var rollbackCallCount = 0
    var updateTransactionCallCount = 0
    
    func begin(transientTransaction: [String : String]) {
        beginCallCount += 1
        transaction = KVTransaction(items: transientTransaction)
    }
    
    func commit() -> Result<KeyValueStore.KVTransaction, KeyValueStore.TransactionErrorReason> {
        commitCallCount += 1
        return shouldFail ? .failure(error!) : .success(transaction!)
    }
    
    func rollback() -> Result<Void, KeyValueStore.TransactionErrorReason> {
        rollbackCallCount += 1
        return shouldFail ? .failure(error!) : .success(())
    }
    
    func updateTransaction(items: [String : String]) {
        updateTransactionCallCount += 1
        if !shouldFail {
            let transaction = KVTransaction(items: items)
            self.transaction = transaction
        }
    }
}
