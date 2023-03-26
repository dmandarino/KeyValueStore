//
//  StackService.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

enum StackError: Error {
    case noTransaction
}

protocol KVStackWorkable {
    func begin(transientTransaction: [String : String])
    func commit() -> Result<KVTransaction, StackError>
    func rollback() -> Result<Void, StackError>
    func updateTransaction(item: [String : String])
}

class KVStackWorker: KVStackWorkable {

    private(set) var transactions: [KVTransaction] = []
    
    init() {}
    
    convenience init(transactions: [KVTransaction]) {
        self.init()
        self.transactions = transactions
    }
    
    func begin(transientTransaction: [String : String]) {
        let transaction = KVTransaction(items: transientTransaction)
        transactions.append(transaction)
    }
    
    func commit() -> Result<KVTransaction, StackError> {
        guard let transaction = removeLastTransaction() else {
            return .failure(.noTransaction)
        }
        if let previousTransaction = transactions.last {
            mergeTransaction(transaction: transaction, in: previousTransaction)
        }
        return .success(transaction)
    }
    
    func rollback() -> Result<Void, StackError> {
        guard removeLastTransaction() != nil else {
            return .failure(.noTransaction)
        }
        return .success(())
    }
    
    func updateTransaction(item: [String : String]) {
        guard !transactions.isEmpty else { return }
        transactions.last?.updateItems(with: item)
    }
    
    // MARK: - Private
    
    private func removeLastTransaction() -> KVTransaction? {
        guard !transactions.isEmpty else {
            return nil
        }
        return transactions.removeLast()
    }
    
    private func mergeTransaction(transaction: KVTransaction, in previousTransaction: KVTransaction) {
        var items = previousTransaction.items
        items.merge(transaction.items) { (_, new) in new }
        transactions.removeLast()
        transactions.append(KVTransaction(items: items))
    }
}
