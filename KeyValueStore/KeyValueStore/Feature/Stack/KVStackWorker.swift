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
    func commit() -> Result<KVTransactionModel, TransactionErrorReason>
    func rollback() -> Result<KVTransactionModel?, TransactionErrorReason>
    func updateTransaction(items: [String : String])
}

class KVStackWorker: KVStackWorkable {

    // MARK: - Private Variables
    private(set) var transactions: [KVTransactionModel] = []
    
    // MARK: - Init
    
    init() {
        config()
    }
    
    convenience init(transactions: [KVTransactionModel]) {
        self.init()
        self.transactions.append(contentsOf: transactions)
    }
    
    // MARK: - KVStackWorkable
    
    func begin(transientTransaction: [String : String]) {
        let transaction = KVTransactionModel(items: transientTransaction)
        transactions.append(transaction)
    }
    
    func commit() -> Result<KVTransactionModel, TransactionErrorReason> {
        guard let transaction = removeLastTransaction(), transactions.count > 0 else {
            return .failure(.noTransaction)
        }
        if let previousTransaction = transactions.last {
            mergeTransaction(transaction: transaction, in: previousTransaction)
        }
        return .success(transaction)
    }
    
    func rollback() -> Result<KVTransactionModel?, TransactionErrorReason> {
        guard removeLastTransaction() != nil, transactions.count > 0 else {
            return .failure(.noTransaction)
        }
        let lastTransaction = transactions.last
        return .success(lastTransaction)
    }
    
    func updateTransaction(items: [String : String]) {
        guard !transactions.isEmpty else { return }
        transactions.last?.updateItems(with: items)
    }
    
    // MARK: - Private Methods
    
    private func removeLastTransaction() -> KVTransactionModel? {
        guard !transactions.isEmpty else {
            return nil
        }
        return transactions.removeLast()
    }
    
    private func mergeTransaction(transaction: KVTransactionModel, in previousTransaction: KVTransactionModel) {
        var items = previousTransaction.items
        items.merge(transaction.items) { (_, new) in new }
        transactions.removeLast()
        transactions.append(KVTransactionModel(items: items))
    }
    
    private func config() {
        let transaction = KVTransactionModel(items: [:])
        self.transactions = [transaction]
    }
}
