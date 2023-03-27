//
//  KVTransactPresentableMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore

public class KVTransactPresentableMock: KVTransactionalInteractableDelegate {
   
    public var presentSuccessCallCount = 0
    public var presentErrorCallCount = 0
    public var response = ""
    public var error: TransactionErrorReason? = .none
    
    public func presentSuccess(response: String) {
        presentSuccessCallCount += 1
        self.response = response
    }
    
    public func presentError(error: TransactionErrorReason) {
        presentErrorCallCount += 1
        self.error = error
    }
}
