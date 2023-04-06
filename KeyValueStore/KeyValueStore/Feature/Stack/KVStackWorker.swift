//
//  KVCommandStackWorker.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 06/04/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVStackWorkable {
    func addCommand(key: String, oldValue: String?)
    func begin()
    func commit() -> Result<Void, TransactionErrorReason>
    func rollback() -> Result<KVTransactionModel?, TransactionErrorReason>
    func clearAll()
}

class KVStackWorker: KVStackWorkable {

    // MARK: - Private Variables
    private(set) var transactions: [KVTransactionModel]
    
    // MARK: - Init
    
    init(transactions: [KVTransactionModel] = []) {
        self.transactions = transactions
    }
    
    // MARK: - KVStackWorkable

    func addCommand(key: String, oldValue: String?) {
        guard let lastStack = transactions.last else {
            return
        }
        lastStack.updateCommands(key: key, value: oldValue)
    }
    
    func begin() {
        let transaction = KVTransactionModel()
        transactions.append(transaction)
    }

    func commit() -> Result<Void, TransactionErrorReason> {
        guard removeLastTransaction() != nil else {
            return .failure(.noTransaction)
        }
        return .success(())
    }

    func rollback() -> Result<KVTransactionModel?, TransactionErrorReason> {
        guard let lastTransaction = removeLastTransaction() else {
            return .failure(.noTransaction)
        }
        return .success(lastTransaction)
    }

    func clearAll() {
        transactions = []
    }

    // MARK: - Private Methods

    private func removeLastTransaction() -> KVTransactionModel? {
        guard !transactions.isEmpty else {
            return nil
        }
        return transactions.removeLast()
    }
}
