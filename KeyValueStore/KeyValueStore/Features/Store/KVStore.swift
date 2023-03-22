//
//  KVStore.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVStoring {
    var store: [String: String] { get set }
}

class KVStore: KVStoring {
    var store: [String: String]
    
    init(store: [String: String] = [:]) {
        self.store = store
    }
}
