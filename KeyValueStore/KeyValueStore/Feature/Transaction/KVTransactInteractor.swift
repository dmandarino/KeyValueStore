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

protocol KVTransactPresentable: AnyObject {
    func presentSuccess(response: String)
    func presentError(error: TransactionErrorReason)
}

final class KVTransactionalInteractor: KVTransactInteractable {
    
    // MARK: - Variables
    
    weak var delegate: KVTransactPresentable?
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
        storeWorker.set(key: key, value: value)
    }
    
    func delete(key: String) {
        guard key.isNotEmpty  else {
            delegate?.presentError(error: .emptyKey)
            return
        }
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

    // MARK: - Stack

    func commit() {
        let result = stackWorker.commit()
        switch result {
        case .success(let transaction):
            storeWorker.updateStore(with: transaction.items)
        case .failure(_):
            delegate?.presentError(error: .noTransaction)
        }
    }

    func begin() {
        guard let transient = storeWorker.getAll() else {
            delegate?.presentError(error: .noStore)
            return
        }
        stackWorker.begin(transientTransaction: transient)
    }

    func rollback() {
        if case .failure(let error) = stackWorker.rollback() {
            delegate?.presentError(error: error)
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
