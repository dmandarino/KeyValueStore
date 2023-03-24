//
//  KVStackWorkerTests.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 24/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore
import XCTest

class KVStackWorkerTests: XCTestCase {
    
    var worker: KVStackWorker?
    
    override func setUp() {
        worker = KVStackWorker()
    }
    
    //MARK: - BEGIN
    
    func test_begin_shouldCreateNewTransaction() {
        //Given
        XCTAssertTrue((worker?.transactions.isEmpty)!)
        
        //When
        worker?.begin()
        
        //Then
        XCTAssertEqual(worker?.transactions.count, 1)
    }
    
    func test_beginWhenThereIsAlreadyTransaction_shouldCreateAnotherTransaction() {
        //Given
        let transaction = KVTransaction(items: ["foo" : "bar"])
        worker = KVStackWorker(transactions: [transaction])
        XCTAssertEqual(worker?.transactions.first!.items, transaction.items)
        
        //When
        worker?.begin()
        
        //Then
        XCTAssertEqual(worker?.transactions.count, 2)
        XCTAssertEqual(worker?.transactions.last!.items, [:])
    }
    
    //MARK: - COMMIT
    
    func test_commit_shouldReturnTransaction() {
        //Given
        let transaction = KVTransaction(items: ["foo" : "bar"])
        worker = KVStackWorker(transactions: [transaction])
        var expectedTransaction: KVTransaction?
        
        //When
        let result = worker?.commit()
        switch result {
        case .success(let lastTransaction):
            expectedTransaction = lastTransaction
        default:
            XCTFail()
        }
        
        //Then
        XCTAssertEqual(worker?.transactions.count, 0)
        XCTAssertEqual(expectedTransaction?.items, ["foo" : "bar"])
    }
    
    func test_commitWhenThereIsMoreTransaction_shouldReturnLastTransaction() {
        //Given
        let transaction = KVTransaction(items: ["foo" : "bar"])
        let transaction2 = KVTransaction(items: ["xpto" : "123"])
        worker = KVStackWorker(transactions: [transaction, transaction2])
        var expectedTransaction: KVTransaction?
        
        //When
        let result = worker?.commit()
        switch result {
        case .success(let lastTransaction):
            expectedTransaction = lastTransaction
        default:
            XCTFail()
        }
        
        //Then
        XCTAssertEqual(worker?.transactions.count, 1)
        XCTAssertEqual(worker?.transactions.last?.items, ["foo" : "bar", "xpto" : "123"])
        XCTAssertEqual(expectedTransaction?.items, ["xpto" : "123"])
    }
    
    func test_commitWhenThereIsNoTransaction_shouldReturnTransaction() {
        //Given
        XCTAssertTrue((worker?.transactions.isEmpty)!)
        var error: StackError?
        
        //When
        let result = worker?.commit()
        switch result {
        case .failure(let err):
            error = err
        default:
            XCTFail()
        }
        
        //Then
        XCTAssertTrue((worker?.transactions.isEmpty)!)
        XCTAssertEqual(worker?.transactions.count, 0)
        XCTAssertEqual(error, .noTransaction)
    }
    
    //MARK: - ROLLBACK
    
    func test_rollback_shouldRemoveTransaction() {
        //Given
        let transaction = KVTransaction(items: ["foo" : "bar"])
        worker = KVStackWorker(transactions: [transaction])
        
        //When
        let result = worker?.rollback()
        switch result {
        case .failure(_):
            XCTFail()
        default:
            break
        }
        
        //Then
        XCTAssertEqual(worker?.transactions.count, 0)
    }
    
    func test_rollbackMoreThanOneTransaction_shouldRemoveLastTransaction() {
        //Given
        let transaction = KVTransaction(items: ["foo" : "bar"])
        let transaction2 = KVTransaction(items: ["xpto" : "123"])
        worker = KVStackWorker(transactions: [transaction, transaction2])
        
        //When
        let result = worker?.rollback()
        switch result {
        case .failure(_):
            XCTFail()
        default:
            break
        }
        
        //Then
        XCTAssertEqual(worker?.transactions.count, 1)
        XCTAssertEqual(worker?.transactions.first?.items, ["foo" : "bar"])
    }
    
    //MARK: - UPDATE TRANSACTION
    
    func test_updateTransaction_shouldUpdateLastTransaction() {
        //Given
        let transaction = KVTransaction(items: ["foo" : "bar"])
        worker = KVStackWorker(transactions: [transaction])
        XCTAssertEqual(worker?.transactions.first!.items, transaction.items)
        
        //When
        worker?.updateTransaction(item: ["abc" : "123"])
        
        //Then
        XCTAssertEqual(worker?.transactions.count, 1)
        XCTAssertEqual(worker?.transactions.last!.items, ["abc" : "123"])
    }
    
    func test_updateTransactionWhenThereIsMoreTransaction_shouldUpdateLastTransaction() {
        //Given
        let transaction = KVTransaction(items: ["foo" : "bar"])
        let transaction2 = KVTransaction(items: ["xpto" : "123"])
        worker = KVStackWorker(transactions: [transaction, transaction2])
        XCTAssertEqual(worker?.transactions.first!.items, ["foo" : "bar"])
        XCTAssertEqual(worker?.transactions.last!.items, ["xpto" : "123"])
        
        //When
        worker?.updateTransaction(item: ["abc" : "123"])
        
        //Then
        XCTAssertEqual(worker?.transactions.count, 2)
        XCTAssertEqual(worker?.transactions.first!.items, ["foo" : "bar"])
        XCTAssertEqual(worker?.transactions.last!.items, ["abc" : "123"])
    }
}
