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
        XCTAssertEqual(stackWorker.addCommandCallCount, 0)
        
        // When
        interactor?.set(key: "abc", value: "123")
        
        // Then
        XCTAssertEqual(storeWorker.setCallCount, 1)
        XCTAssertEqual(stackWorker.addCommandCallCount, 1)
        XCTAssertEqual(storeWorker.expectedStore, ["abc": "123"])
        XCTAssertEqual(stackWorker.key, "abc")
        XCTAssertNil(stackWorker.oldValue)
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
        XCTAssertEqual(storeWorker.expectedStore, [:])
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
        let transactional = Transactional(key: "abc", value: "123")
        stackWorker.transactions = [KVTransactionModel(commands: [transactional])]
        
        // When
        interactor?.delete(key: "abc")
        
        // Then
        XCTAssertEqual(storeWorker.deleteCallCount, 1)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        XCTAssertEqual(stackWorker.key, "abc")
        XCTAssertNil(stackWorker.oldValue)
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
        XCTAssertEqual(storeWorker.deleteCallCount, 0)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        storeWorker.shouldFail = true
        
        // When
        interactor?.delete(key: "abc")
        
        // Then
        XCTAssertEqual(storeWorker.deleteCallCount, 1)
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
    
    func test_handleWithError_shouldPresentCorrectError() {
        //Given
        XCTAssertEqual(delegate.presentErrorCallCount, 0)
        
        // When
        interactor?.handleWithError(error: .noTransaction)
        
        // Then
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
        XCTAssertEqual(delegate.error, .noTransaction)
    }
    
    //MARK: - STACK
    
    func test_begin_shouldCreateNewTransaction() {
        //Given
        storeWorker.expectedStore = ["abc": "123"]
        XCTAssertEqual(stackWorker.beginCallCount, 0)
        
        // When
        interactor?.begin()
        
        // Then
        XCTAssertEqual(stackWorker.beginCallCount, 1)
//        XCTAssertEqual(stackWorker.transaction?.commands, ["abc": "123"])
    }
    
    func test_rollback_shouldCallRollBack() {
        //Given
        XCTAssertEqual(stackWorker.rollbackCallCount, 0)

        // When
        interactor?.rollback()

        // Then
        XCTAssertEqual(stackWorker.rollbackCallCount, 1)
    }
    
    func test_rollbackWhenShouldFail_shouldPresentError() {
        //Given
        stackWorker.shouldFail = true
        stackWorker.error = .noTransaction
        XCTAssertEqual(stackWorker.rollbackCallCount, 0)

        // When
        interactor?.rollback()

        // Then
        XCTAssertEqual(stackWorker.rollbackCallCount, 1)
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
        XCTAssertEqual(delegate.error, .noTransaction)
    }
    
    func test_commit_shouldCallCommit() {
        //Given
        XCTAssertEqual(stackWorker.commitCallCount, 0)

        // When
        interactor?.commit()

        // Then
        XCTAssertEqual(stackWorker.commitCallCount, 1)
    }
    
    func test_commitWhenFail_shouldPresentError() {
        //Given
        stackWorker.error = .noTransaction
        stackWorker.shouldFail = true
        XCTAssertEqual(stackWorker.commitCallCount, 0)

        // When
        interactor?.commit()

        // Then
        XCTAssertEqual(stackWorker.commitCallCount, 1)
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
    }
}
