//
//  KVStoreServiceTests.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore
import XCTest

class KVStoreServiceTests: XCTestCase {
    
    var service: KVStoreService?
    var store = KVStore()

    override func setUp() {
        service = KVStoreService(store: store)
    }
    
    //MARK: - SET

    func test_setKeyValue_shouldInsertAValue() {
        //Given
        var status: Result<Void, KVStoreError>?
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
        var status: Result<Void, KVStoreError>?
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
        var status: Result<String, KVStoreError>?
        var result = ""
        store = KVStore(store: ["foo":"123"])
        service = KVStoreService(store: store)
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
        var status: Result<String, KVStoreError>?
        var result = ""
        store = KVStore(store: ["foo":"123"])
        service = KVStoreService(store: store)
        XCTAssertEqual(store.store, ["foo":"123"])

        //When
        service?.set(key: "foo", value: "abc")
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
        var status: Result<String, KVStoreError>?
        var result: KVStoreError? = .none
        store = KVStore(store: ["foo":"123"])
        service = KVStoreService(store: store)
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
        XCTAssertEqual(result, KVStoreError.keyNotFound)
    }
}
