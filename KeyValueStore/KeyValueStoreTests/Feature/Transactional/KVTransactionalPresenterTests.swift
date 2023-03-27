//
//  KVTransactionalPresenterTests.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 27/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore
import XCTest

class KVTransactionalPresenterTests: XCTestCase {
    
    var interactor = KVTransactionalInteractorMock()
    var presenter: KVTransactionalPresenter?
    
    override func setUp() {
        presenter = KVTransactionalPresenter(interactor: interactor)
        interactor.delegate = presenter
    }
    
    func test_executeTransaction_shouldCallInteractorWithCorrectMethod() {
        XCTAssertEqual(interactor.beginCallCount, 0)
        XCTAssertEqual(interactor.commitCallCount, 0)
        XCTAssertEqual(interactor.rollbackCallCount, 0)
        XCTAssertEqual(interactor.countCallCount, 0)
        
        presenter?.execute(transaction: .BEGIN)
        presenter?.execute(transaction: .COMMIT)
        presenter?.execute(transaction: .ROLLBACK)
        presenter?.execute(transaction: .COUNT)
        
        XCTAssertEqual(interactor.beginCallCount, 1)
        XCTAssertEqual(interactor.commitCallCount, 1)
        XCTAssertEqual(interactor.rollbackCallCount, 1)
        XCTAssertEqual(interactor.countCallCount, 0)
    }
    
    func test_executeMethod_shouldCallInteractorWithCorrectMethod() {
        XCTAssertEqual(interactor.beginCallCount, 0)
        XCTAssertEqual(interactor.setCallCount, 0)
        XCTAssertEqual(interactor.getCallCount, 0)
        XCTAssertEqual(interactor.deleteCallCount, 0)
        XCTAssertEqual(interactor.countCallCount, 0)
        
        presenter?.execute(method: .BEGIN, key: "key", value: "value")
        presenter?.execute(method: .SET, key: "key", value: "value")
        presenter?.execute(method: .GET, key: "key", value: "value")
        presenter?.execute(method: .DELETE, key: "key", value: "value")
        presenter?.execute(method: .COUNT, key: "key", value: "value")
        
        
        XCTAssertEqual(interactor.beginCallCount, 0)
        XCTAssertEqual(interactor.setCallCount, 1)
        XCTAssertEqual(interactor.getCallCount, 1)
        XCTAssertEqual(interactor.deleteCallCount, 1)
        XCTAssertEqual(interactor.countCallCount, 1)
    }
    
    func test_executeFreeForm_shouldCallInteractorWithCorrectMethod() {
        XCTAssertEqual(interactor.beginCallCount, 0)
        XCTAssertEqual(interactor.setCallCount, 0)
        XCTAssertEqual(interactor.getCallCount, 0)
        XCTAssertEqual(interactor.deleteCallCount, 0)
        XCTAssertEqual(interactor.countCallCount, 0)
        
        presenter?.execute(freeForm: "SET foo bar")
        XCTAssertEqual(presenter?.response, "\n> SET foo bar")
        presenter?.execute(freeForm: "SET foo bar 124")
        XCTAssertEqual(presenter?.response, "sintax error")
        
        presenter?.response = ""
        
        presenter?.execute(freeForm: "GET foo")
        XCTAssertEqual(presenter?.response, "\n> GET foo")
        presenter?.execute(freeForm: "COUNT bar")
        presenter?.execute(freeForm: "DELETE foo")
        presenter?.execute(freeForm: "DELETE foo bar")
        
        XCTAssertEqual(interactor.beginCallCount, 0)
        XCTAssertEqual(interactor.setCallCount, 1)
        XCTAssertEqual(interactor.getCallCount, 1)
        XCTAssertEqual(interactor.deleteCallCount, 1)
        XCTAssertEqual(interactor.countCallCount, 1)
        XCTAssertEqual(presenter?.response, "sintax error")
        
    }
}
