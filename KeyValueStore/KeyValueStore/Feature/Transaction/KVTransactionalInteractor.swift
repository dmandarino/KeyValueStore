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

protocol KVTransactionalInteractable: KVTransacional {
    var delegate: KVTransactionalInteractableDelegate? { get set }
    func set(key: String, value: String)
    func delete(key: String)
    func get(key: String)
    func count(value: String)
    func clearAll()
}

protocol KVTransactionalInteractableDelegate: AnyObject {
    func presentSuccess(response: String)
    func presentError(error: TransactionErrorReason)
}

final class KVTransactionalInteractor: KVTransactionalInteractable {
    
    // MARK: - Variables
    
    weak var delegate: KVTransactionalInteractableDelegate?
    private var storeWorker: KVStoreWorkable
    private var stackWorker: KVStackWorkable
    
    // MARK: - init
    
    init(storeWorker: KVStoreWorkable, stackWorker: KVStackWorkable) {
        self.storeWorker = storeWorker
        self.stackWorker = stackWorker
    }
    
    // MARK: - KVTransactInteractable
    

    func set(key: String, value: String) {
        guard key.isNotEmpty && value.isNotEmpty else {
            delegate?.presentError(error: .emptyParameters)
            return
        }
        updateCommandTransactionalStack(key: key)
        storeWorker.set(key: key, value: value)
    }
    
    func delete(key: String) {
        guard key.isNotEmpty  else {
            delegate?.presentError(error: .emptyKey)
            return
        }
        updateCommandTransactionalStack(key: key)
        storeWorker.delete(by: key)
    }

    func get(key: String) {
        guard key.isNotEmpty  else {
            delegate?.presentError(error: .emptyKey)
            return
        }
        storeWorker.get(by: key)
    }

    func count(value: String) {
        guard value.isNotEmpty  else {
            delegate?.presentError(error: .emptyParameters)
            return
        }
        storeWorker.count(for: value)
    }

    func clearAll() {
        storeWorker.clearStore()
        stackWorker.clearAll()
    }

    // MARK: - Stack
    
    func begin() {
        stackWorker.begin()
    }
    
    func commit() {
        let result = stackWorker.commit()
        if case .failure(let error) = result {
            delegate?.presentError(error: error)
        }
    }
    
    func rollback() {
        let result = stackWorker.rollback()
        switch result {
        case .success(let transaction):
            guard let transaction else {
                delegate?.presentError(error: .noTransaction)
                return
            }
            rollbackCommands(transaction: transaction)
        case .failure(let error):
            delegate?.presentError(error: error)
        }
    }

    private func rollbackCommands(transaction: KVTransactionModel) {
        let commands = transaction.commands
        for command in commands {
            if let value = command.value {
                set(key: command.key, value: value)
            } else {
                delete(key: command.key)
            }
        }
    }
    
    // MARK: - Private Methods

    private func updateCommandTransactionalStack(key: String) {
        guard let stored = storeWorker.getAll() else {
            return
        }
        if let oldValue = stored[key] {
            stackWorker.addCommand(key: key, oldValue: oldValue)
        } else {
            stackWorker.addCommand(key: key, oldValue: nil)
        }
    }
}

extension KVTransactionalInteractor: KVStoreWorkerDelegate {
   
    func didGetValueForKey(value: String) {
        delegate?.presentSuccess(response: value)
    }
    
    func handleWithError(error: TransactionErrorReason) {
        delegate?.presentError(error: error)
    }
}
