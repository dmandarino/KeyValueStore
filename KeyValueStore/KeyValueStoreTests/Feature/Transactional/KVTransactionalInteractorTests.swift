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
    
    let storeService = KVStoreServicingMock()
    let stackService = KVStackServicingMock()
    let delegate = KVTransactPresentableMock()
    var interactor: KVTransactionalInteractor?
    
    override func setUp() {
        interactor = KVTransactionalInteractor(storeService: storeService, stackService: stackService)
        interactor?.delegate = delegate
    }
    
    //MARK: - SET
    
    func test_setKeyValue_shoulCallsetInStoreService() {
        //Given
        XCTAssertEqual(storeService.setCallCount, 0)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        
        // When
        interactor?.set(key: "abc", value: "123")
        
        // Then
        XCTAssertEqual(storeService.setCallCount, 1)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
    }
    
    func test_setKeyValue_whenFails_shoulPresentError() {
        //Given
        XCTAssertEqual(storeService.setCallCount, 0)
        XCTAssertEqual(delegate.presentErrorCallCount, 0)
        storeService.shouldPass = false
        
        // When
        interactor?.set(key: "abc", value: "123")
        
        // Then
        XCTAssertEqual(storeService.setCallCount, 1)
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
        XCTAssertEqual(delegate.error, .emptyKey)
    }
    
    //MARK: - GET
    
    func test_getValue_shoulCallGetInStoreServiceAndDelegate() {
        //Given
        XCTAssertEqual(storeService.getCallCount, 0)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        storeService.successString = "abc"
        
        // When
        interactor?.get(key: "abc")
        
        // Then
        XCTAssertEqual(storeService.getCallCount, 1)
        XCTAssertEqual(delegate.presentSuccessCallCount, 1)
        XCTAssertEqual(delegate.response, "abc")
    }
    
    func test_getValue_whenFails_shoulPresentError() {
        //Given
        XCTAssertEqual(storeService.setCallCount, 0)
        XCTAssertEqual(delegate.presentErrorCallCount, 0)
        storeService.shouldPass = false
        
        // When
        interactor?.get(key: "abc")
        
        // Then
        XCTAssertEqual(storeService.getCallCount, 1)
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
        XCTAssertEqual(delegate.error, .keyNotFound)
    }
    
    //MARK: - DELETE
    
    func test_deleteValue_shoulCallDeleteInStoreServiceAndDelegate() {
        //Given
        XCTAssertEqual(storeService.deleteCallCount, 0)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        
        // When
        interactor?.delete(key: "abc")
        
        // Then
        XCTAssertEqual(storeService.deleteCallCount, 1)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
    }
    
    func test_deleteValue_whenEmptyKey_shoulPresentError() {
        //Given
        XCTAssertEqual(storeService.deleteCallCount, 0)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        storeService.shouldPass = false
        storeService.error = .emptyKey
        
        // When
        interactor?.delete(key: "")
        
        // Then
        XCTAssertEqual(storeService.deleteCallCount, 1)
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
        XCTAssertEqual(delegate.error, .emptyKey)
    }
    
    func test_deleteValue_whenFails_shoulPresentError() {
        //Given
        XCTAssertEqual(storeService.deleteCallCount, 0)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        storeService.shouldPass = false
        storeService.error = .keyNotFound
        
        // When
        interactor?.delete(key: "")
        
        // Then
        XCTAssertEqual(storeService.deleteCallCount, 1)
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
        XCTAssertEqual(delegate.error, .keyNotFound)
    }
    
    //MARK: - COUNT
    
    func test_countValue_shoulCallCountInStoreServiceAndDelegate() {
        //Given
        XCTAssertEqual(storeService.countCallCount, 0)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        storeService.successInt = 5
        
        // When
        interactor?.count(value: "456")
        
        // Then
        XCTAssertEqual(storeService.countCallCount, 1)
        XCTAssertEqual(delegate.presentSuccessCallCount, 1)
        XCTAssertEqual(delegate.response, "5")
    }
    
    func test_countValue_whenFailsBecauseThereIsNoValue_shoulPresentError() {
        //Given
        XCTAssertEqual(storeService.countCallCount, 0)
        XCTAssertEqual(delegate.presentSuccessCallCount, 0)
        storeService.shouldPass = false
        
        // When
        interactor?.count(value: "456")
        
        // Then
        XCTAssertEqual(storeService.countCallCount, 1)
        XCTAssertEqual(delegate.presentErrorCallCount, 1)
        XCTAssertEqual(delegate.error, .emptyValue)
    }
}
