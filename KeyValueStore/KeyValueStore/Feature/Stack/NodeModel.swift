//
//  NodeModel.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

public enum Action {
    case DELETE
    case SET
}

struct Transaction {
    let action: Action
    let key: String
    
    init(action: Action, key: String) {
        self.action = action
        self.key = key
    }
}
