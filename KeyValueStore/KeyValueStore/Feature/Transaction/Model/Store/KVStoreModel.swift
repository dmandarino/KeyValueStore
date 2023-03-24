//
//  KVStore.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVStoring {
    var items: [String: String] { get set }
}

final class KVStore: KVStoring {
    
    var items: [String: String]
    
    init(items: [String: String] = [:]) {
        self.items = items
    }
}
