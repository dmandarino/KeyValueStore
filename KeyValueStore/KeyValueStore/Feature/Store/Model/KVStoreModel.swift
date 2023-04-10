//
//  KVStore.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

/*
    Local in memory storage. This is where there could be a replace of storage framework.
*/
protocol KVStoring {
    @discardableResult func updateStore(with items: [String : String]) -> [String : String]
    func getStore() -> [String : String]?
    func getValue(by key: String) -> String?
    func delete(by key: String) -> String?
    func clearStore()
}

final class KVStoreModel: KVStoring {

    private var items: [String: String]
    
    init(items: [String: String] = [:]) {
        self.items = items
    }
    
    func updateStore(with items: [String : String]) -> [String : String] {
        self.items = items
        return self.items
    }
    
    func getStore() -> [String : String]? {
        self.items
    }
    
    func getValue(by key: String) -> String? {
        self.items[key]
    }
    
    func delete(by key: String) -> String? {
        guard let item = items.removeValue(forKey: key) else {
            return nil
        }
        return item
    }
    
    func clearStore() {
        self.items = [:]
    }
    
}
