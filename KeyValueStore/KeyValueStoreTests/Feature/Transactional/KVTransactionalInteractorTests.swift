//
//  KVTransactionalInteractorTests.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore
import XCTest

class KVTransactionalInteractorTests: XCTestCase {
    
    let storeWorker = KVStoreWorkerMock()
    let stackWorker = KVStackWorkerMock()
    let delegate = KVTransactPresentableMock()
    var interactor: KVTransactionalInteractor?
    
    override func setUp() {
        interactor = KVTransactionalInteractor(storeWorker: storeWorker, stackWorker: stackWorker)
        interactor?.delegate = delegate
    }
    
    //MARK: - SET
    
    func test_setKeyValue_shoulCallsetInStoreWorker() {
        //Given
        XCTAssertEqual(storeWorker.setCallCount, 0)
        
        // When
        interactor?.set(key: "abc", value: "123")
        
        // Then
        XCTAssertEqual(storeWorker.setCallCount, 1)
        XCTAssertEqual(storeWorker.store, ["abc": "123"])
    }
    
    func test_setKeyValueWhenShouldFail_callDelegateToPresentErorr() {
        //Given
        storeWorker.shouldFail = true
        XCTAssertEqual(storeWorker.setCallCount, 0)
        XCTAssertEqual(delegate.presentErrorCallCount, 0)
        
        // When
        interactor?.set(key: "abc", value: "123")
        
        // Then
        XCTAssertEqual(storeWorker.setCallCount, 1)
        XCTAssertEqual(storeWorker.store, [:])
    }
    
    func test_setKeyEmptyKey_shouldFail() {
        //Given
        XCTAssertEqual(storeWorker.setCallCount, 0)
        XCTAssertEqual(delegate.presentErrorCallCount, 0)
        
        // When
        interactor?.set(key: "", value: "123")
        
        // Then
        XCTAssertEqual(storeWorker.setCallCount, 0)
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
        XCTAssertEqual(delegate.error, .emptyParameters)
    }
    
    //MARK: - GET
    
    func test_getValue_shoulCallGetInstoreWorkerAndDelegate() {
        //Given
        XCTAssertEqual(storeWorker.getCallCount, 0)
        
        // When
        interactor?.get(key: "abc")
        
        // Then
        XCTAssertEqual(storeWorker.getCallCount, 1)
    }
    
    func test_getValueWhenKeyIsEmpty_shoulFail() {
        //Given
        XCTAssertEqual(storeWorker.getCallCount, 0)
        
        // When
        interactor?.get(key: "")
        
        // Then
        XCTAssertEqual(storeWorker.getCallCount, 0)
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
        XCTAssertEqual(delegate.error, .emptyKey)
    }
    
    //MARK: - DELETE
    
    func test_deleteValue_shoulCallDeleteInstoreWorkerAndDelegate() {
        //Given
        XCTAssertEqual(storeWorker.deleteCallCount, 0)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        
        // When
        interactor?.delete(key: "abc")
        
        // Then
        XCTAssertEqual(storeWorker.deleteCallCount, 1)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
    }
    
    func test_deleteValue_whenEmptyKey_shoulPresentError() {
        //Given
        XCTAssertEqual(storeWorker.deleteCallCount, 0)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        
        // When
        interactor?.delete(key: "")
        
        // Then
        XCTAssertEqual(storeWorker.deleteCallCount, 0)
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
        XCTAssertEqual(delegate.error, .emptyKey)
    }
    
    func test_deleteValue_whenFails_shoulPresentError() {
        //Given
        storeWorker.store = ["abc": "123"]
        XCTAssertEqual(storeWorker.deleteCallCount, 0)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        storeWorker.shouldFail = true
        
        // When
        interactor?.delete(key: "abc")
        
        // Then
        XCTAssertEqual(storeWorker.deleteCallCount, 1)
        XCTAssertEqual(storeWorker.store, ["abc": "123"])
    }
    
    //MARK: - COUNT
    
    func test_countValue_shoulCallCountInstoreWorkerAndDelegate() {
        //Given
        XCTAssertEqual(storeWorker.countCallCount, 0)
        
        // When
        interactor?.count(value: "456")
        
        // Then
        XCTAssertEqual(storeWorker.countCallCount, 1)
    }
    
    func test_countValueWhenThereIsNoKey_shoulPresentError() {
        //Given
        XCTAssertEqual(storeWorker.countCallCount, 0)
        storeWorker.shouldFail = true
        
        // When
        interactor?.count(value: "")
        
        // Then
        XCTAssertEqual(storeWorker.countCallCount, 0)
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
        XCTAssertEqual(delegate.error, .emptyParameters)
    }
    
    // MARK: - KVStoreWorkerDelegate
    
    func test_didGetValueForKey_shouldPresentSuccess() {
        //Given
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        
        // When
        interactor?.didGetValueForKey(value: "abc")
        
        // Then
        XCTAssertEqual(delegate.presentSuccessCallCount, 1)
        XCTAssertEqual(delegate.response, "abc")
    }
    
    func test_didGetAllTransactions_shouldPresentSuccess() {
        //Given
        XCTAssertEqual(stackWorker.updateTransactionCallCount, 0)
        
        // When
        interactor?.didGetAllTransactions(transactions: ["abc": "123"])
        
        // Then
        XCTAssertEqual(stackWorker.updateTransactionCallCount, 1)
    }
    
    func test_handleWithError_shouldPresentCorrectError() {
        //Given
        XCTAssertEqual(delegate.presentErrorCallCount, 0)
        
        // When
        interactor?.handleWithError(error: .noTransaction)
        
        // Then
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
        XCTAssertEqual(delegate.error, .noTransaction)
    }
}
