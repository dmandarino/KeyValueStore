//
//  TransactionModel.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

struct Transactional: Equatable {
    var key: String
    var value: String?
}

protocol KVTransactional {
    var commands: [Transactional] { get }
    
    func updateCommands(key: String, value: String?)
}

class KVTransactionModel: KVTransactional {
    
    var commands: [Transactional]
    
    init(commands: [Transactional] = []) {
        self.commands = commands
    }
    
    func updateCommands(key: String, value: String?) {
        let command = Transactional(key: key, value: value)
        self.commands.insert(command, at: 0)
    }
}

extension KVTransactionModel: Equatable {
    static func == (lhs: KVTransactionModel, rhs: KVTransactionModel) -> Bool {
        if lhs.commands.count == rhs.commands.count, lhs.commands == rhs.commands {
            return true
        }
        return false
    }
}
