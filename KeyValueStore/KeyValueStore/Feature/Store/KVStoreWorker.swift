//
//  KVStoreService.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 24/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVStoreWorkerDelegate: AnyObject {
    func didGetValueForKey(value: String)
    func didGetAllTransactions(transactions: [String: String])
    func handleWithError(error: TransactionErrorReason)
}

protocol KVStoreWorkable {
    func updateStore(with transactions: [String: String])
    func set(key: String, value: String)
    func delete(by key: String)
    func get(by key: String)
    func count(for value: String)
    func getAll()
}

final class KVStoreWorker: KVStoreWorkable {
    
    // MARK: - Public Variables
    
    var delegate: KVStoreWorkerDelegate?
    
    // MARK: - Private Variables
    
    private var service: KVStoreServicing
    
    // MARK: - Init
    
    init(service: KVStoreServicing) {
        self.service = service
    }
    
    // MARK: - KVStoreWorkable
    
    func updateStore(with transactions: [String : String]) {
        let result = service.getAll()
        switch result {
        case .success(let oldTransactions):
            updateTransactionsByKey(oldTransactions: oldTransactions, newTransactions: transactions)
        case .failure(let error):
            sendError(error: error)
        }
    }
    
    func set(key: String, value: String) {
        guard key.isNotEmpty && value.isNotEmpty else {
            delegate?.handleWithError(error: .emptyKey)
            return
        }
        if case let .failure(error) = service.set(key: key, value: value) {
            sendError(error: error)
        }
    }
    
    func delete(by key: String) {
        guard key.isNotEmpty else {
            delegate?.handleWithError(error: .emptyKey)
            return
        }
        if case let .failure(error) = service.delete(key: key) {
            sendError(error: error)
        }
    }
    
    func get(by key: String) {
        guard key.isNotEmpty else {
            delegate?.handleWithError(error: .emptyKey)
            return
        }
        let operation = service.get(key: key)
        switch operation {
        case .success(let result):
            delegate?.didGetValueForKey(value: result)
        case .failure(let error):
            sendError(error: error)
        }
    }
    
    func getAll() {
        let operation = service.getAll()
        switch operation {
        case .success(let result):
            delegate?.didGetAllTransactions(transactions: result)
        case .failure(let error):
            sendError(error: error)
        }
    }
    
    func count(for value: String) {
        let operation = service.count(value: value)
        switch operation {
        case .success(let result):
            delegate?.didGetValueForKey(value: "\(result)")
        case .failure(let error):
            sendError(error: error)
        }
    }
    
    // MARK: - Private Methods
    
    private func sendError(error: KVStoreError) {
        let error = TransactionErrorReason.match(error: error)
        delegate?.handleWithError(error: error)
    }
    
    private func updateTransactionsByKey(oldTransactions: [String: String], newTransactions: [String: String]) {
        var stored = oldTransactions
        stored.merge(newTransactions) { (_, new) in new }
        if case let .failure(error) = service.updateStore(items: stored) {
            sendError(error: error)
        }
    }
}
