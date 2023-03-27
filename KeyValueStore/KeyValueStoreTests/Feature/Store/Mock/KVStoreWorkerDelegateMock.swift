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
    
    var didGetValueForKeyCallCount = 0
    var handleWithErrorCallCount = 0
    
    func didGetValueForKey(value: String) {
        didGetValueForKeyCallCount += 1
        expectedValue = value
    }
    
    func handleWithError(error: KeyValueStore.TransactionErrorReason) {
        handleWithErrorCallCount += 1
        expectedError = error
    }
}
