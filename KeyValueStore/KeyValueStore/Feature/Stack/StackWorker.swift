//
//  StackService.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVStackWorkable {
    func begin(transientTransaction: [String : String])
    func commit() -> Result<KVTransaction, TransactionErrorReason>
    func rollback() -> Result<Void, TransactionErrorReason>
    func updateTransaction(items: [String : String])
}

class KVStackWorker: KVStackWorkable {

    // MARK: - Private Variables
    private(set) var transactions: [KVTransaction] = []
    
    // MARK: - Init
    
    init() {}
    
    convenience init(transactions: [KVTransaction]) {
        self.init()
        self.transactions = transactions
    }
    
    // MARK: - KVStackWorkable
    
    func begin(transientTransaction: [String : String]) {
        let transaction = KVTransaction(items: transientTransaction)
        transactions.append(transaction)
    }
    
    func commit() -> Result<KVTransaction, TransactionErrorReason> {
        guard let transaction = removeLastTransaction() else {
            return .failure(.noTransaction)
        }
        if let previousTransaction = transactions.last {
            mergeTransaction(transaction: transaction, in: previousTransaction)
        }
        return .success(transaction)
    }
    
    func rollback() -> Result<Void, TransactionErrorReason> {
        guard removeLastTransaction() != nil else {
            return .failure(.noTransaction)
        }
        return .success(())
    }
    
    func updateTransaction(items: [String : String]) {
        guard !transactions.isEmpty else { return }
        transactions.last?.updateItems(with: items)
    }
    
    // MARK: - Private Methods
    
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
