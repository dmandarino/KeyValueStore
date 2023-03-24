//
//  KVStoreServiceTests.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 24/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore
import XCTest

class KVStoreWorkerTests: XCTestCase {

    var service: KVStoreWorker?
    var storeMock = KVStoreMock()

    override func setUp() {
        service = KVStoreWorker(store: storeMock)
    }
    
    //MARK: - SET

    func test_setKeyValue_shouldInsertAValue() {
        //Given
        XCTAssertEqual(storeMock.items, [:])
        
        //When
        service?.set(key: "foo", value: "123")
        
        //Then
        XCTAssertEqual(storeMock.items["foo"], "123")
    }
    
    func test_setKeyValueForSameKey_shouldUpdate() {
        //Given
        XCTAssertEqual(storeMock.items, [:])
        
        //When
        service?.set(key: "foo", value: "123")
        service?.set(key: "foo", value: "abc")
        
        //Then
        XCTAssertEqual(storeMock.items["foo"], "abc")
    }
    
    //MARK: - GET

    func test_getKeyValue_shouldGetValueByKey() {
        //Given
        storeMock = KVStoreMock(store: ["foo":"123"])
        service = KVStoreWorker(store: storeMock)
        XCTAssertEqual(storeMock.items, ["foo":"123"])

        //When
        let result = service?.get(key: "foo")

        //Then
        XCTAssertEqual(result, "123")
    }
    
    func test_getKeyDoesNotExist_shouldReturnNil() {
        //Given
        storeMock = KVStoreMock(store: ["foo":"123"])
        service = KVStoreWorker(store: storeMock)
        XCTAssertEqual(storeMock.items, ["foo":"123"])

        //When
        let result = service?.get(key: "bar")

        //Then
        XCTAssertNil(result)
    }
    
    //MARK: - DELETE
    
    func test_deleteValueByKey_shouldDeleteTheKey() {
        //Given
        storeMock = KVStoreMock(store: ["foo":"123", "bar":"456"])
        service = KVStoreWorker(store: storeMock)
        XCTAssertEqual(storeMock.items, ["foo":"123", "bar":"456"])
        
        //When
        service?.delete(key: "foo")
        
        //Then
        XCTAssertNil(storeMock.items["foo"])
        XCTAssertEqual(storeMock.items, ["bar":"456"])
    }
    
    func test_deleteValueWhenThereIsNoKey_shouldFail() {
        //Given
        storeMock = KVStoreMock(store: ["foo":"123", "bar":"456"])
        service = KVStoreWorker(store: storeMock)
        XCTAssertEqual(storeMock.items, ["foo":"123", "bar":"456"])
        
        //When
        service?.delete(key: "xpto")
        
        //Then
        XCTAssertEqual(storeMock.items, ["foo":"123", "bar":"456"])
    }
    
    //MARK: - GET ALL
    
    func test_getAll_shouldReturnAllValuesInStore() {
        //Given
        storeMock = KVStoreMock(store: ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"])
        service = KVStoreWorker(store: storeMock)
        
        //When
        let result = service?.getAll()
        
        //Then
        XCTAssertEqual(result, ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"])
    }
    
    func test_getAllWhenItsEmpty_shouldReturnAllValuesInStore() {
        //Given
        XCTAssertEqual(storeMock.items, [:])
        
        //When
        let result = service?.getAll()
        
        //Then
        XCTAssertEqual(result, [:])
    }
    
    //MARK: - UPDATE STORE
    
    func test_updateStore_shoulAddNewTrasactions() {
        //Given
        storeMock = KVStoreMock(store: ["foo":"123", "bar":"456"])
        service = KVStoreWorker(store: storeMock)
        let transactions = ["blz":"abc", "xpto":"456"]
        
        //When
        service?.updateStore(with: transactions)
        
        //Then
        XCTAssertEqual(storeMock.items, ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"])
    }
    
    func test_updateStore_shoulMergeNewTrasactions() {
        //Given
        storeMock = KVStoreMock(store: ["foo":"123", "bar":"456"])
        service = KVStoreWorker(store: storeMock)
        let transactions = ["foo":"abc", "xpto":"456"]
        
        //When
        service?.updateStore(with: transactions)
        
        //Then
        XCTAssertEqual(storeMock.items, ["foo":"abc", "bar":"456", "xpto":"456"])
    }
}
