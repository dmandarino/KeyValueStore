//
//  KVStackServiceMock.swift
//  KeyValueStoreTests
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import KeyValueStore

class KVStackServicingMock: KVStackServicing {
    var shouldPass: Bool = false
    var error: KVStoreError? = .none
    var successString = ""
    var successInt = 0
    
    var pushCallCount = 0
    var popCallCount = 0
    
    func push(action: Action, key: String) {
        
    }
    
    func pop() -> (Action, key: String)? {
        return nil
    }
    
}
