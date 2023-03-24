////
////  KVSExamplesTests.swift
////  KeyValueStoreTests
////
////  Created by Douglas Mandarino on 22/03/23.
////  Copyright © 2023 Douglas Mandarino. All rights reserved.
////
//
//@testable import KeyValueStore
//import XCTest
//
//class KVSExamplesTests: XCTestCase {
//    
//    var service: KVTransactionService?
//    var store = KVStore()
//
//    override func setUp() {
//        service = KVTransactionService(store: store)
//    }
//
//    func test_setAndGetAValue() {
//        //Given
//        var status: Result<Void, KVTransactionError>?
//        XCTAssertEqual(store.items, [:])
//        
//        //When
//        status = service?.set(key: "foo", value: "123")
//        
//        //Then
//        switch status {
//        case .success(_):
//            break
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(store.items["foo"], "123")
//    }
//    
//    func test_deleteAValue() {
//        //Given
//        var status: Result<String, KVTransactionError>?
//        var result: KVTransactionError? = .none
//        store = KVStore(store: ["foo":"123"])
//        service = KVTransactionService(store: store)
//        XCTAssertEqual(store.items, ["foo": "123"])
//        
//        //When
//        _ = service?.delete(key: "foo")
//        status = service?.get(key: "foo")
//        
//        //Then
//        switch status {
//        case .failure(let error):
//            result = error
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(result, KVTransactionError.keyNotFound)
//    }
//    
//    func test_countTheNumberOfOccurrencesOfAValue() {
//        var status: Result<Int, KVTransactionError>?
//        var result = 0
//        XCTAssertEqual(store.items, [:])
//        
//        _ = service?.set(key: "foo", value: "123")
//        _ = service?.set(key: "bar", value: "456")
//        _ = service?.set(key: "baz", value: "123")
//        status = service?.count(value: "123")
//        
//        switch status {
//        case .success(let num):
//            result = num
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(result, 2)
//        
//        status = service?.count(value: "456")
//        
//        switch status {
//        case .success(let num):
//            result = num
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(result, 1)
//    }
//}
