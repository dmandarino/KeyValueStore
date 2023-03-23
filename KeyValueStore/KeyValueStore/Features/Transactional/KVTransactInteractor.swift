//
//  KVTransaciotnalInteractor.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVTransacional {
    func commit()
    func begin()
    func rollback()
}

protocol KVTransactInteractable: KVTransacional {
    func set(key: String, value: String)
    func delete(key: String)
    func get(key: String)
    func count(value: String)
}

@objc protocol KVTransactPresentable: Any {
    func presentResponse(message: String)
}

final class KVTransactInteractor: KVTransactInteractable {
    
    weak var delegate: KVTransactPresentable?
    private var storeService: KVStoreServicing
    private var stackService: KVStackServicing
    
    init(storeService: KVStoreServicing, stackService: KVStackServicing) {
        self.storeService = storeService
        self.stackService = stackService
    }
    
    // MARK: - KVTransactInteractable
    
    func set(key: String, value: String) {
        
    }
    
    func delete(key: String) {
        
    }
    
    func get(key: String) {
        
    }
    
    func count(value: String) {
        
    }
    
    // MARK: - Transactional
    
    func commit() {
        
    }
    
    func begin() {
        
    }
    
    func rollback() {
        
    }
}
