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
    let store = KVStore()

    override func setUp() {
        service = KVStoreService(store: store)
    }
    
    //MARK: - SET

    func test_setKeyValue_shouldInsertAValue() {
        //Given
        XCTAssertEqual(store.store, [:])
        
        //When
        service?.set(key: "foo", value: "123")
        
        //Then
        XCTAssertEqual(store.store["foo"], "123")
    }
    
    func test_setKeyValueForSameKey_shouldInsertAValue() {
        //Given
        XCTAssertEqual(store.store, [:])
        
        //When
        service?.set(key: "foo", value: "123")
        service?.set(key: "foo", value: "abc")
        
        //Then
        XCTAssertEqual(store.store["foo"], "abc")
    }
    
    //MARK: - GET
    
    func test_getKeyValue_shouldGetValueByKey() {
        //Given
        XCTAssertEqual(store.store, [:])
        service?.set(key: "foo", value: "123")
        
        //When
        let result = service?.get(key: "foo")
        
        //Then
        XCTAssertEqual(result, "123")
    }
    
    func test_getKeyValueAfterSettingForSameKey_shouldGetLatestKey() {
        //Given
        XCTAssertEqual(store.store, [:])
        service?.set(key: "foo", value: "123")
        service?.set(key: "foo", value: "abc")

        //When
        let result = service?.get(key: "foo")

        //Then
        XCTAssertEqual(result, "abc")
    }
}
