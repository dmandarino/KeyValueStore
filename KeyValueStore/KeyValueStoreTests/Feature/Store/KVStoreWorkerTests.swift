//
//  KVStoreWorkerTests.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 26/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore
import XCTest

class KVStoreWorkerTests: XCTestCase {

    var delegate = KVStoreWorkerDelegateMock()
    var serviceMock = KVStoreServiceMock()
    var worker: KVStoreWorker?

    override func setUp() {
        worker = KVStoreWorker(service: serviceMock)
        worker?.delegate = delegate
    }
    
    //MARK: - SET

    func test_setKeyValue_shouldInsertAValue() {
        //Given
        XCTAssertEqual(serviceMock.items, [:])

        //When
        worker?.set(key: "foo", value: "123")

        //Then
        XCTAssertEqual(serviceMock.setCallCount, 1)
        XCTAssertEqual(delegate.handleWithErrorCallCount, 0)
    }

    func test_setKeyValueForSameKey_shouldUpdate() {
        //Given
        XCTAssertEqual(serviceMock.items, [:])

        //When
        worker?.set(key: "foo", value: "123")
        worker?.set(key: "foo", value: "abc")

        //Then
        XCTAssertEqual(serviceMock.setCallCount, 2)
        XCTAssertEqual(delegate.handleWithErrorCallCount, 0)
    }

    //MARK: - GET

    func test_getKeyValue_shouldGetValueByKey() {
        //Given
        serviceMock.expectedValue = "123"
        worker = KVStoreWorker(service: serviceMock)
        worker?.delegate = delegate

        //When
        worker?.get(by: "foo")

        //Then
        XCTAssertEqual(serviceMock.getCallCount, 1)
        XCTAssertEqual(delegate.expectedValue, "123")
        XCTAssertEqual(delegate.handleWithErrorCallCount, 0)
    }

    func test_getKeyDoesNotExist_shouldReturnNil() {
        //Given
        serviceMock.shouldFail = true
        serviceMock.error = .keyNotFound
        worker = KVStoreWorker(service: serviceMock)
        worker?.delegate = delegate

        //When
        worker?.get(by: "foo")

        //Then
        XCTAssertEqual(serviceMock.getCallCount, 1)
        XCTAssertEqual(delegate.expectedValue, "")
        XCTAssertEqual(delegate.handleWithErrorCallCount, 1)
    }

    //MARK: - DELETE

    func test_deleteValueByKey_shouldDeleteTheKey() {
        //Given
        XCTAssertEqual(serviceMock.items, [:])

        //When
        worker?.delete(by: "foo")

        //Then
        XCTAssertEqual(serviceMock.deleteCallCount, 1)
        XCTAssertEqual(delegate.handleWithErrorCallCount, 0)
    }

    func test_deleteValueWhenThereIsNoValue_shouldFail() {
        //Given
        serviceMock.shouldFail = true
        serviceMock.error = .keyNotFound
        worker = KVStoreWorker(service: serviceMock)
        worker?.delegate = delegate
        
        //When
        worker?.delete(by: "foo")

        //Then
        XCTAssertEqual(serviceMock.deleteCallCount, 1)
        XCTAssertEqual(delegate.handleWithErrorCallCount, 1)
        XCTAssertEqual(delegate.expectedError, .keyNotFound)
    }

    func test_deleteValueWhenThereIsNoKey_shouldFail() {
        //Given
        XCTAssertEqual(serviceMock.items, [:])

        //When
        worker?.delete(by: "")

        //Then
        XCTAssertEqual(serviceMock.deleteCallCount, 0)
        XCTAssertEqual(delegate.handleWithErrorCallCount, 1)
    }

    //MARK: - GET ALL

    func test_getAll_shouldReturnAllValuesInStore() {
        //Given
        serviceMock.items = ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"]
        worker = KVStoreWorker(service: serviceMock)
        worker?.delegate = delegate

        //When
        let result = worker?.getAll()
    
        //Then
        XCTAssertEqual(result, ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"])
        XCTAssertEqual(serviceMock.updateStoreCallCount, 0)
        XCTAssertEqual(serviceMock.getAllCallCount, 1)
    }

    func test_getAllWhenItsEmpty_shouldReturnAllValuesInStore() {
        //Given
        XCTAssertEqual(serviceMock.items, [:])

        //When
        let result = worker?.getAll()
    
        //Then
        XCTAssertEqual(result, [:])
        XCTAssertEqual(delegate.handleWithErrorCallCount, 0)
        XCTAssertEqual(serviceMock.getAllCallCount, 1)
    }

    func test_getAllWhenFails_shouldReturnNoStore() {
        //Given
        serviceMock.error = .noStore
        serviceMock.shouldFail = true

        //When
        let result = worker?.getAll()
    
        //Then
        XCTAssertNil(result)
        XCTAssertEqual(delegate.handleWithErrorCallCount, 1)
        XCTAssertEqual(delegate.expectedError, .noStore)
        XCTAssertEqual(serviceMock.getAllCallCount, 1)
    }

    //MARK: - UPDATE STORE

    func test_updateStore_shoulAddNewTrasactions() {
        //Given
        serviceMock.items = ["foo":"123", "bar":"456", "blz":"abc"]
        worker = KVStoreWorker(service: serviceMock)
        worker?.delegate = delegate
        let items = ["blz":"abc", "xpto":"456"]

        //When
        worker?.updateStore(with: items)
        
        //Then
        XCTAssertEqual(serviceMock.updateStoreCallCount, 1)
        XCTAssertEqual(serviceMock.getAllCallCount, 1)
        XCTAssertEqual(serviceMock.items, ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"])
    }

    func test_updateStore_shoulMergeNewTrasactions() {
        //Given
        serviceMock.items = ["foo":"123", "bar":"456", "blz":"abc"]
        serviceMock.shouldFail = true
        serviceMock.error = .noStore
        worker = KVStoreWorker(service: serviceMock)
        worker?.delegate = delegate
        let items = ["blz":"abc", "xpto":"456"]

        //When
        worker?.updateStore(with: items)
        
        //Then
        XCTAssertEqual(serviceMock.updateStoreCallCount, 0)
        XCTAssertEqual(serviceMock.getAllCallCount, 1)
        XCTAssertEqual(serviceMock.items, ["foo":"123", "bar":"456", "blz":"abc"])
        XCTAssertEqual(delegate.handleWithErrorCallCount, 1)
        XCTAssertEqual(delegate.expectedError, .noStore)
    }
    
    //MARK: - COUNT

    func test_count_shoulReturnNumberOfElements() {
        //Given
        serviceMock.items = ["foo":"123", "bar":"abc", "blz":"abc"]
        serviceMock.expectedCount = 2
        worker = KVStoreWorker(service: serviceMock)
        worker?.delegate = delegate

        //When
        worker?.count(for: "abc")
        
        //Then
        XCTAssertEqual(serviceMock.countCallCount, 1)
        XCTAssertEqual(delegate.didGetValueForKeyCallCount, 1)
        XCTAssertEqual(delegate.expectedValue, "2")
    }
    
    func test_countWhenFails_shoulReturnNotFoundError() {
        //Given
        serviceMock.items = ["foo":"123", "bar":"abc", "blz":"abc"]
        serviceMock.expectedCount = 2
        serviceMock.error = .keyNotFound
        serviceMock.shouldFail = true
        worker = KVStoreWorker(service: serviceMock)
        worker?.delegate = delegate

        //When
        worker?.count(for: "abc")
        
        //Then
        XCTAssertEqual(serviceMock.countCallCount, 1)
        XCTAssertEqual(delegate.didGetValueForKeyCallCount, 0)
        XCTAssertEqual(delegate.expectedError, .keyNotFound)
        XCTAssertEqual(delegate.expectedValue, "")
    }
}

