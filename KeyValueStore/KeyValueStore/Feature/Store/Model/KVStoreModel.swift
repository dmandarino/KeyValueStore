//
//  KVStore.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVStoring {
    @discardableResult func updateStore(with items: [String : String]) -> [String : String]
    func getStore() -> [String : String]
}

final class KVStore: KVStoring {
    
    private var items: [String: String]
    
    init(items: [String: String] = [:]) {
        self.items = items
    }
    
    func updateStore(with items: [String : String]) -> [String : String] {
        self.items = items
        return self.items
    }
    
    func getStore() -> [String : String] {
        self.items
    }
    
}
