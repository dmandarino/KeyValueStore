//
//  StackServiceTests.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

@testable import KeyValueStore
import XCTest

class KVStackServiceTests: XCTestCase {
    
    var service: KVStackService?
    
    override func setUp() {
        service = KVStackService()
        KVStack.items = []
    }
    
    override func tearDown() {
        KVStack.items = []
    }
    
    //MARK: - PUSH
    
    func test_pushActionWhenStackIsNil_shouldCreateNewNode() {
        //Given
        XCTAssertTrue(KVStack.items.isEmpty)
        
        //When
        service?.push(action: .SET, key: "foo")
        
        //Then
        let firstNode = KVStack.items.first!
        XCTAssertEqual(KVStack.items.count, 1)
        XCTAssertEqual(firstNode.first?.action, .SET)
        XCTAssertEqual(firstNode.first?.key, "foo")
    }
    
    func test_pushActionNonEmptyStack_shouldInsertNewNode() {
        //Given
        KVStack.items = [[Transaction(action: .DELETE, key: "foo")]]
        
        //When
        service?.push(action: .SET, key: "bar")
        
        //Then
        let firstNode = KVStack.items.first!
        XCTAssertEqual(KVStack.items.count, 1)
        XCTAssertEqual(firstNode.last?.action, .SET)
        XCTAssertEqual(firstNode.last?.key, "bar")
    }
    
    //MARK: - PUSH
    
    func test_popWhenThereIsOnlyOneValue_shouldReturnLastActionAndKey() {
        //Given
        KVStack.items = [[Transaction(action: .DELETE, key: "foo")]]
        
        //When
        guard let (action, key) = service?.pop() else {
            XCTFail()
            return
        }
        
        //Then
        XCTAssertEqual(KVStack.items.count, 0)
        XCTAssertEqual(action, .DELETE)
        XCTAssertEqual(key, "foo")
    }
    
    func test_popWhenThereIsMoreThanOneNode_shouldReturnLastActionAndKey() {
        //Given
        KVStack.items = [[Transaction(action: .DELETE, key: "foo"), Transaction(action: .SET, key: "bar")]]
        
        //When
        guard let (action, key) = service?.pop() else {
            XCTFail()
            return
        }
        
        //Then
        XCTAssertEqual(KVStack.items.count, 1)
        XCTAssertEqual(KVStack.items.last!.count, 1)
        XCTAssertEqual(action, .SET)
        XCTAssertEqual(key, "bar")
    }
    
    func test_popWhenThereIsMoreThanOneStack_shouldReturnLastActionAndKey() {
        //Given
        KVStack.items = [[Transaction(action: .DELETE, key: "foo"), Transaction(action: .SET, key: "bar")], [Transaction(action: .DELETE, key: "xpto")]]
        
        //When
        guard let (action, key) = service?.pop() else {
            XCTFail()
            return
        }
        
        //Then
        let lastNode = KVStack.items.last!.last!
        XCTAssertEqual(KVStack.items.count, 1)
        XCTAssertEqual(lastNode.action, .SET)
        XCTAssertEqual(lastNode.key, "bar")
        XCTAssertEqual(action, .DELETE)
        XCTAssertEqual(key, "xpto")
    }
}
