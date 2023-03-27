//
//  KVTransactionServiceTests.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore
import XCTest


class KVTransactionIntegrationTests: XCTestCase {
    
    var interactor: KVTransactionalInteractable?
    private let delegate = InteractorDelegateMock()
    
    override func setUp() {
        interactor = KVTransactionalBuilder().build()
        interactor?.delegate = delegate
    }
    
    func test_getAValue() {
        interactor?.set(key: "foo", value: "123")
        interactor?.get(key: "foo")
        XCTAssertEqual(delegate.response, "123")
    }
    
    func test_deleteAValue() {
        interactor?.set(key: "foo", value: "123")
        interactor?.delete(key: "foo")
        interactor?.get(key: "foo")
        XCTAssertEqual(delegate.error, .keyNotFound)
    }
    
    func test_CountTheNumberOfOccurencesOfAValue() {
        interactor?.set(key: "foo", value: "123")
        interactor?.set(key: "bar", value: "456")
        interactor?.set(key: "baz", value: "123")
        interactor?.count(value: "123")
        XCTAssertEqual(delegate.response, "2")
        interactor?.count(value: "456")
        XCTAssertEqual(delegate.response, "1")
    }
    
    func test_commitATransaction() {
        interactor?.set(key: "bar", value: "123")
        interactor?.get(key: "bar")
        XCTAssertEqual(delegate.response, "123")
        interactor?.begin()
        interactor?.set(key: "foo", value: "456")
        interactor?.get(key: "bar")
        XCTAssertEqual(delegate.response, "123")
        interactor?.delete(key: "bar")
        interactor?.commit()
        interactor?.get(key: "bar")
        XCTAssertEqual(delegate.error, .keyNotFound)
        interactor?.rollback()
        XCTAssertEqual(delegate.error, .noTransaction)
        interactor?.get(key: "foo")
        XCTAssertEqual(delegate.response, "456")
    }
    
    func test_rollbackATransaction() {
        interactor?.set(key: "foo", value: "123")
        interactor?.set(key: "bar", value: "abc")
        interactor?.begin()
        interactor?.set(key: "foo", value: "456")
        interactor?.get(key: "foo")
        XCTAssertEqual(delegate.response, "456")
        interactor?.set(key: "bar", value: "def")
        interactor?.get(key: "bar")
        XCTAssertEqual(delegate.response, "def")
        interactor?.rollback()
        interactor?.get(key: "foo")
        XCTAssertEqual(delegate.response, "123")
        interactor?.get(key: "bar")
        XCTAssertEqual(delegate.response, "abc")
        interactor?.commit()
        XCTAssertEqual(delegate.error, .noTransaction)
    }
    
    func test_nestedTransactions() {
        interactor?.set(key: "foo", value: "123")
        interactor?.set(key: "bar", value: "456")
        interactor?.begin()
        interactor?.set(key: "foo", value: "456")
        interactor?.begin()
        interactor?.count(value: "456")
        XCTAssertEqual(delegate.response, "2")
        interactor?.get(key: "foo")
        XCTAssertEqual(delegate.response, "456")
        interactor?.set(key: "foo", value: "789")
        interactor?.get(key: "foo")
        XCTAssertEqual(delegate.response, "789")
        interactor?.rollback()
        interactor?.get(key: "foo")
        XCTAssertEqual(delegate.response, "456")
        interactor?.delete(key: "foo")
        interactor?.get(key: "foo")
        XCTAssertEqual(delegate.error, .keyNotFound)
        interactor?.rollback()
        interactor?.get(key: "foo")
        XCTAssertEqual(delegate.response, "123")
    }
    
    private class InteractorDelegateMock: KVTransactionalInteractableDelegate {
        var response = ""
        var error: TransactionErrorReason? = .none
        
        func presentSuccess(response: String) {
            self.response = response
        }
        
        func presentError(error: KeyValueStore.TransactionErrorReason) {
            self.error = error
        }
    }
    
}
