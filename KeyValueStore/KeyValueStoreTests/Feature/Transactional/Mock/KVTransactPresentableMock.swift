//
//  KVTransactPresentableMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import KeyValueStore

private class KVTransactPresentableMock: KVTransactPresentable {
   
    var presentSuccessCallCount = 0
    var presentErrorCallCount = 0
    var response = ""
    var error: TransactionalErrorReason? = .none
    
    func presentSuccess(response: String) {
        presentSuccessCallCount += 1
        self.response = response
    }
    
    func presentError(error: TransactionalErrorReason) {
        presentErrorCallCount += 1
        self.error = error
    }
}
