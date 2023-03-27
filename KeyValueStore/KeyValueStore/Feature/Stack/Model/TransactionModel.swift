//
//  TransactionModel.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVTransactional {
    var items: [String : String] { get }
    
    func updateItems(with items: [String : String])
}

class KVTransactionModel: KVTransactional {
    
    var items: [String : String]
    
    init(items: [String : String] = [:]) {
        self.items = items
    }
    
    func updateItems(with items: [String : String]) {
        self.items = items
    }
}

extension KVTransactionModel: Equatable {
    static func == (lhs: KVTransactionModel, rhs: KVTransactionModel) -> Bool {
        lhs.items == rhs.items
    }
}
