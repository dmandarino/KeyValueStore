//
//  KVTransactionServiceTests.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore
import XCTest

class KVTransactionServiceTests: XCTestCase {
    
    var service: KVTransactionService?
    var store = KVStoreMock()

    override func setUp() {
        service = KVTransactionService(store: store)
    }
    
    //MARK: - SET

    func test_setKeyValue_shouldInsertAValue() {
        //Given
        var status: Result<Void, KVTransactionError>?
        XCTAssertEqual(store.store, [:])
        
        //When
        status = service?.set(key: "foo", value: "123")
        
        //Then
        switch status {
        case .success(_):
            break
        default:
            XCTFail()
        }
        XCTAssertEqual(store.store["foo"], "123")
    }
    
    func test_setKeyValueForSameKey_shouldInsertAValue() {
        //Given
        var status: Result<Void, KVTransactionError>?
        XCTAssertEqual(store.store, [:])
        
        //When
        status = service?.set(key: "foo", value: "123")
        status = service?.set(key: "foo", value: "abc")
        
        //Then
        switch status {
        case .success(_):
            break
        default:
            XCTFail()
        }
        XCTAssertEqual(store.store["foo"], "abc")
    }
    
    //MARK: - GET

    func test_getKeyValue_shouldGetValueByKey() {
        //Given
        var status: Result<String, KVTransactionError>?
        var result = ""
        store = KVStoreMock(store: ["foo":"123"])
        service = KVTransactionService(store: store)
        XCTAssertEqual(store.store, ["foo":"123"])

        //When
        status = service?.get(key: "foo")

        //Then
        switch status {
        case .success(let value):
            result = value
        default:
            XCTFail()
        }
        XCTAssertEqual(result, "123")
    }

    func test_getKeyValueAfterSettingAnotherValueForSameKey_shouldGetLatestKey() {
        //Given
        var status: Result<String, KVTransactionError>?
        var result = ""
        store = KVStoreMock(store: ["foo":"123"])
        service = KVTransactionService(store: store)
        XCTAssertEqual(store.store, ["foo":"123"])

        //When
        _ = service?.set(key: "foo", value: "abc")
        status = service?.get(key: "foo")

        //Then
        switch status {
        case .success(let value):
            result = value
        default:
            XCTFail()
        }
        XCTAssertEqual(result, "abc")
    }
    
    func test_getKeyDoesNotExist_shouldReturnNil() {
        //Given
        var status: Result<String, KVTransactionError>?
        var result: KVTransactionError? = .none
        store = KVStoreMock(store: ["foo":"123"])
        service = KVTransactionService(store: store)
        XCTAssertEqual(store.store, ["foo":"123"])
        
        //When
        status = service?.get(key: "bar")
        
        //Then
        switch status {
        case .failure(let error):
            result = error
        default:
            XCTFail()
        }
        XCTAssertEqual(result, KVTransactionError.keyNotFound)
    }
    
    //MARK: - DELETE
    
    func test_deleteValueByKey_shouldDeleteTheKeyAndReturnSuccess() {
        //Given
        var status: Result<Void, KVTransactionError>?
        store = KVStoreMock(store: ["foo":"123", "bar":"456"])
        service = KVTransactionService(store: store)
        
        //When
        status = service?.delete(key: "foo")
        
        //Then
        switch status {
        case .success():
            break
        default:
            XCTFail()
        }
        XCTAssertNil(store.store["foo"])
    }
    
    func test_deleteValueWhenKeyIsEmpty_shouldFail() {
        //Given
        var status: Result<Void, KVTransactionError>?
        var result: KVTransactionError? = .none
        store = KVStoreMock(store: ["foo":"123", "bar":"456"])
        service = KVTransactionService(store: store)
        
        //When
        status = service?.delete(key: "")
        
        //Then
        switch status {
        case .failure(let error):
            result = error
        default:
            XCTFail()
        }
        XCTAssertEqual(result, KVTransactionError.emptyKey)
    }
    
    
    func test_deleteValueWhenThereIsNoKey_shouldFail() {
        //Given
        var status: Result<Void, KVTransactionError>?
        var result: KVTransactionError? = .none
        store = KVStoreMock(store: ["foo":"123", "bar":"456"])
        service = KVTransactionService(store: store)
        
        //When
        status = service?.delete(key: "beta")
        
        //Then
        switch status {
        case .failure(let error):
            result = error
        default:
            XCTFail()
        }
        XCTAssertEqual(result, KVTransactionError.keyNotFound)
    }
    
    //MARK: - COUNT
    
    func test_countValueOneValue_shouldReturnNumberOfMatchedValue() {
        //Given
        var status: Result<Int, KVTransactionError>?
        var result = 0
        store = KVStoreMock(store: ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"])
        service = KVTransactionService(store: store)
        
        //When
        status = service?.count(value: "abc")
        
        //Then
        switch status {
        case .success(let value):
            result = value
        default:
            XCTFail()
        }
        XCTAssertEqual(result, 1)
    }
    
    func test_countValueWhenBiggerThanOne_shouldReturnNumberOfMatchedValue() {
        //Given
        var status: Result<Int, KVTransactionError>?
        var result = 0
        store = KVStoreMock(store: ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"])
        service = KVTransactionService(store: store)
        
        //When
        status = service?.count(value: "456")
        
        //Then
        switch status {
        case .success(let value):
            result = value
        default:
            XCTFail()
        }
        XCTAssertEqual(result, 2)
    }
    
    func test_countValueWhenEmptyValue_shouldFail() {
        //Given
        var status: Result<Int, KVTransactionError>?
        var result: KVTransactionError? = .none
        store = KVStoreMock(store: ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"])
        service = KVTransactionService(store: store)
        
        //When
        status = service?.count(value: "")
        
        //Then
        switch status {
        case .failure(let error):
            result = error
        default:
            XCTFail()
        }
        XCTAssertEqual(result, KVTransactionError.emptyValue)
    }
    
    func test_countValueWhenThereIsNoValue_shouldFail() {
        //Given
        var status: Result<Int, KVTransactionError>?
        var result = 0
        store = KVStoreMock(store: ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"])
        service = KVTransactionService(store: store)
        
        //When
        status = service?.count(value: "xpto")
        
        //Then
        switch status {
        case .success(let value):
            result = value
        default:
            XCTFail()
        }
        XCTAssertEqual(result, 0)
    }
}
