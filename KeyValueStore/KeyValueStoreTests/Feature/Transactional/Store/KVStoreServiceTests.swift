//
//  KVStoreServiceTests.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 24/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore
import XCTest

class KVStoreServiceTests: XCTestCase {

    var service: KVStoreServicing?
    var storeMock = KVStoreMock()

    override func setUp() {
        service = KVStoreService(store: storeMock)
    }
    
    //MARK: - SET

    func test_setKeyValue_shouldInsertAValue() {
        //Given
        XCTAssertEqual(storeMock.items, [:])
        
        //When
        service?.set(key: "foo", value: "123")
        
        //Then
        XCTAssertEqual(storeMock.items!["foo"], "123")
        XCTAssertEqual(storeMock.getStoreCallCount, 1)
        XCTAssertEqual(storeMock.updateStoreCallCount, 1)
    }
    
    func test_setKeyValueForSameKey_shouldUpdate() {
        //Given
        XCTAssertEqual(storeMock.items, [:])
        
        //When
        service?.set(key: "foo", value: "123")
        service?.set(key: "foo", value: "abc")
        
        //Then
        XCTAssertEqual(storeMock.items!["foo"], "abc")
        XCTAssertEqual(storeMock.getStoreCallCount, 2)
        XCTAssertEqual(storeMock.updateStoreCallCount, 2)
    }
    
    //MARK: - GET

    func test_getKeyValue_shouldGetValueByKey() {
        //Given
        storeMock = KVStoreMock(items: ["foo":"123"])
        storeMock.valueExpected = "123"
        service = KVStoreService(store: storeMock)

        //When
        guard case let .success(result) = service?.get(key: "foo") else {
            XCTFail()
            return
        }

        //Then
        XCTAssertEqual(result, "123")
        XCTAssertEqual(storeMock.getValueCallCount, 1)
    }

    func test_getKeyDoesNotExist_shouldReturnNil() {
        //Given
        storeMock = KVStoreMock()
        storeMock.shouldFail = true
        service = KVStoreService(store: storeMock)

        //When
        guard case let .failure(result) = service?.get(key: "bar") else {
            XCTFail()
            return
        }

        //Then
        XCTAssertEqual(result, .keyNotFound)
        XCTAssertEqual(storeMock.getValueCallCount, 1)
    }

    //MARK: - DELETE

    func test_deleteValueByKey_shouldDeleteTheKey() {
        //Given
        storeMock = KVStoreMock(items: ["foo":"123", "bar":"456"])
        service = KVStoreService(store: storeMock)
        storeMock.deleteExpected = "123"

        //When
        guard case .success(let value) = service?.delete(key: "bar") else {
            XCTFail()
            return
        }

        //Then
        XCTAssertEqual(storeMock.deleteCallCount, 1)
        XCTAssertEqual(storeMock.deleteExpected, value)
    }
    
    func test_deleteValueWhenThereIsNoValue_shouldFail() {
        //Given
        storeMock = KVStoreMock(items: ["foo":"123", "bar":"456"])
        storeMock.shouldFail = true
        service = KVStoreService(store: storeMock)

        //When
        guard case let .failure(result) = service?.delete(key: "xpto") else {
            XCTFail()
            return
        }

        //Then
        XCTAssertEqual(result, .keyNotFound)
        XCTAssertEqual(storeMock.deleteCallCount, 1)
    }

    func test_deleteValueWhenThereIsNoKey_shouldFail() {
        //Given
        storeMock = KVStoreMock(items: ["foo":"123", "bar":"456"])
        storeMock.shouldFail = true
        service = KVStoreService(store: storeMock)

        //When
        guard case let .failure(result) = service?.delete(key: "") else {
            XCTFail()
            return
        }

        //Then
        XCTAssertEqual(result, .emptyKey)
    }

    //MARK: - GET ALL

    func test_getAll_shouldReturnAllValuesInStore() {
        //Given
        storeMock = KVStoreMock(items: ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"])
        service = KVStoreService(store: storeMock)

        //When
        guard case let .success(result) = service?.getAll() else {
            XCTFail()
            return
        }

        //Then
        XCTAssertEqual(result, ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"])
        XCTAssertEqual(storeMock.updateStoreCallCount, 0)
        XCTAssertEqual(storeMock.getStoreCallCount, 1)
    }

    func test_getAllWhenItsEmpty_shouldReturnAllValuesInStore() {
        //Given
        XCTAssertEqual(storeMock.items, [:])

        //When
        guard case let .success(result) = service?.getAll() else {
            XCTFail()
            return
        }

        //Then
        XCTAssertEqual(result, [:])
        XCTAssertEqual(storeMock.updateStoreCallCount, 0)
        XCTAssertEqual(storeMock.getStoreCallCount, 1)
    }
    
    func test_getAllWhenFails_shouldReturnNoStore() {
        //Given
        storeMock.shouldFail = true

        //When
        guard case let .failure(result) = service?.getAll() else {
            XCTFail()
            return
        }

        //Then
        XCTAssertEqual(result, .noStore)
        XCTAssertEqual(storeMock.updateStoreCallCount, 0)
        XCTAssertEqual(storeMock.getStoreCallCount, 1)
    }
    
    //MARK: - UPDATE STORE

    func test_updateStore_shoulAddNewTrasactions() {
        //Given
        storeMock = KVStoreMock(items: ["foo":"123", "bar":"456"])
        service = KVStoreService(store: storeMock)
        let items = ["blz":"abc", "xpto":"456"]

        //When
        guard case .success(_) = service?.updateStore(items: items) else {
            XCTFail()
            return
        }

        //Then
        XCTAssertEqual(storeMock.updateStoreCallCount, 1)
        XCTAssertEqual(storeMock.getStoreCallCount, 1)
    }

    func test_updateStore_shoulMergeNewTrasactions() {
        //Given
        storeMock = KVStoreMock(items: ["foo":"123", "bar":"456"])
        storeMock.shouldFail = true
        service = KVStoreService(store: storeMock)
        let items = ["foo":"abc", "xpto":"456"]

        //When
        guard case let .failure(result) = service?.updateStore(items: items) else {
            XCTFail()
            return
        }

        //Then
        XCTAssertEqual(result, .noStore)
        XCTAssertEqual(storeMock.updateStoreCallCount, 0)
        XCTAssertEqual(storeMock.getStoreCallCount, 1)
    }
}
