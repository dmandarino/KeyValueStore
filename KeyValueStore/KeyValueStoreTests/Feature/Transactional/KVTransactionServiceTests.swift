//
//  KVTransactionServiceTests.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore
import XCTest

//class KVTransactionServiceTests: XCTestCase {
//    
//    var service: KVTransactionService?
//    var worker = KVStoreWorkerMock()
//
//    override func setUp() {
//        worker = KVStoreWorkerMock()
//        worker.store = ["foo":"123"]
//        service = KVTransactionService(worker: worker)
//    }
//    
//    //MARK: - SET
//
//    func test_setKeyValue_shouldInsertAValue() {
//        //Given
//        var status: Result<Void, KVStoreError>?
//        
//        //When
//        status = service?.set(key: "bar", value: "456")
//        
//        //Then
//        switch status {
//        case .success(_):
//            break
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(worker.setCallCount, 1)
//    }
//    
//    func test_setEmptyKey_shouldFail() {
//        //Given
//        var status: Result<Void, KVStoreError>?
//        worker.shouldPass = false
//        var error: KVStoreError?
//
//        //When
//        status = service?.set(key: "", value: "123")
//
//        //Then
//        switch status {
//        case .failure(let err):
//            error = err
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(error, .emptyKey)
//        XCTAssertEqual(worker.setCallCount, 0)
//    }
//
//    //MARK: - GET
//
//    func test_getKeyValue_shouldGetValueByKey() {
//        //Given
//        var status: Result<String, KVStoreError>?
//        var result = ""
//
//        //When
//        status = service?.get(key: "foo")
//
//        //Then
//        switch status {
//        case .success(let value):
//            result = value
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(result, "123")
//        XCTAssertEqual(worker.getCallCount, 1)
//    }
//
//    func test_getKeyValueAfterSettingAnotherValueForSameKey_shouldGetLatestKey() {
//        //Given
//        var status: Result<String, KVStoreError>?
//        var result = ""
//
//        //When
//        _ = service?.set(key: "foo", value: "abc")
//        status = service?.get(key: "foo")
//
//        //Then
//        switch status {
//        case .success(let value):
//            result = value
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(result, "abc")
//        XCTAssertEqual(worker.getCallCount, 1)
//    }
//
//    func test_getKeyDoesNotExist_shouldReturnNil() {
//        //Given
//        var status: Result<String, KVStoreError>?
//        var result: KVStoreError? = .none
//
//        //When
//        status = service?.get(key: "bar")
//
//        //Then
//        switch status {
//        case .failure(let error):
//            result = error
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(result, KVStoreError.keyNotFound)
//        XCTAssertEqual(worker.getCallCount, 1)
//    }
//
//    //MARK: - DELETE
//
//    func test_deleteValueByKey_shouldDeleteTheKeyAndReturnSuccess() {
//        //Given
//        var status: Result<Void, KVStoreError>?
//        worker.store = ["foo":"123", "bar":"456"]
//        var didSuccess = false
//        
//        //When
//        status = service?.delete(key: "foo")
//
//        //Then
//        switch status {
//        case .success():
//            didSuccess = true
//        default:
//            XCTFail()
//        }
//        XCTAssertTrue(didSuccess)
//        XCTAssertEqual(worker.deleteCallCount, 1)
//    }
//
//    func test_deleteValueWhenThereIsNoKey_shouldFail() {
//        //Given
//        var status: Result<Void, KVStoreError>?
//        var result: KVStoreError? = .none
//        worker.store = ["foo":"123", "bar":"456"]
//        service = KVTransactionService(worker: worker)
//        
//        //When
//        status = service?.delete(key: "")
//
//        //Then
//        switch status {
//        case .failure(let error):
//            result = error
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(result, KVStoreError.emptyKey)
//    }
//
//    func test_deleteWhenFail_shouldFailWithKeyNotFound() {
//        //Given
//        var status: Result<Void, KVStoreError>?
//        var result: KVStoreError? = .none
//        worker.store = ["foo":"123", "bar":"456"]
//        worker.shouldPass = false
//
//        //When
//        status = service?.delete(key: "beta")
//
//        //Then
//        switch status {
//        case .failure(let error):
//            result = error
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(result, KVStoreError.keyNotFound)
//    }
//
//    //MARK: - COUNT
//
//    func test_countValueOneValue_shouldReturnNumberOfMatchedValue() {
//        //Given
//        var status: Result<Int, KVStoreError>?
//        var result = 0
//        worker.store = ["foo":"123", "bar":"456"]
//        service = KVTransactionService(worker: worker)
//
//        //When
//        status = service?.count(value: "456")
//
//        //Then
//        switch status {
//        case .success(let value):
//            result = value
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(result, 1)
//    }
//
//    func test_countValueWhenBiggerThanOne_shouldReturnNumberOfMatchedValue() {
//        //Given
//        var status: Result<Int, KVStoreError>?
//        var result = 0
//        worker.store = ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"]
//        service = KVTransactionService(worker: worker)
//
//        //When
//        status = service?.count(value: "456")
//
//        //Then
//        switch status {
//        case .success(let value):
//            result = value
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(result, 2)
//    }
//
//    func test_countValueWhenEmptyValue_shouldFail() {
//        //Given
//        var status: Result<Int, KVStoreError>?
//        var result: KVStoreError? = .none
//        worker.store = ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"]
//        service = KVTransactionService(worker: worker)
//
//        //When
//        status = service?.count(value: "")
//
//        //Then
//        switch status {
//        case .failure(let error):
//            result = error
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(result, KVStoreError.emptyValue)
//    }
//
//    func test_countValueWhenThereIsNoValue_shouldFail() {
//        //Given
//        var status: Result<Int, KVStoreError>?
//        var result = 0
//        worker.store = ["foo":"123", "bar":"456", "blz":"abc", "xpto":"456"]
//        service = KVTransactionService(worker: worker)
//
//        //When
//        status = service?.count(value: "xpto")
//
//        //Then
//        switch status {
//        case .success(let value):
//            result = value
//        default:
//            XCTFail()
//        }
//        XCTAssertEqual(result, 0)
//    }
//}
