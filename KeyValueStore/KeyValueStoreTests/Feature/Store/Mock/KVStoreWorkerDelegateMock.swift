//
//  KVStoreWorkerDelegateMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 26/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore

final class KVStoreWorkerDelegateMock: KVStoreWorkerDelegate {
    var expectedError: TransactionErrorReason? = .none
    var expectedValue = ""
    var expectedTransactions: [String: String] = [:]
    
    var didGetValueForKey = 0
    var didGetAllTransactionsCallCount = 0
    var handleWithErrorCallCount = 0
    
    func didGetValueForKey(value: String) {
        didGetValueForKey += 1
        expectedValue = value
    }
    
    func didGetAllTransactions(transactions: [String : String]) {
        didGetAllTransactionsCallCount += 1
        expectedTransactions = transactions
    }
    
    func handleWithError(error: KeyValueStore.TransactionErrorReason) {
        handleWithErrorCallCount += 1
        expectedError = error
    }
}
