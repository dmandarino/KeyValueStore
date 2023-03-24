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

protocol KVTransactPresentable: class {
    func presentSuccess(response: String)
    func presentError(error: TransactionalErrorReason)
}

final class KVTransactionalInteractor: KVTransactInteractable {

    // MARK: - Variables

    weak var delegate: KVTransactPresentable?
    private var storeService: KVTransactionServicing
    private var stackService: KVStackServicing

    // MARK: - init

    init(storeService: KVTransactionServicing, stackService: KVStackServicing) {
        self.storeService = storeService
        self.stackService = stackService
    }

    // MARK: - KVTransactInteractable

    func set(key: String, value: String) {
        let result = storeService.set(key: key, value: value)
        storeResultVoidHandler(result: result)
    }

    func delete(key: String) {
        let result = storeService.delete(key: key)
        storeResultVoidHandler(result: result)
    }

    func get(key: String) {
        let result = storeService.get(key: key)
        switch result {
        case .failure(let error):
            self.errorHandler(error: error)
        case .success(let value):
            delegate?.presentSuccess(response: value)
        }
    }

    func count(value: String) {
        let result = storeService.count(value: value)
        switch result {
        case .failure(let error):
            self.errorHandler(error: error)
        case .success(let value):
            delegate?.presentSuccess(response: "\(value)")
        }
    }

    // MARK: - Transactional

    func commit() {

    }

    func begin() {

    }

    func rollback() {

    }

    // MARK: - Private

    func storeResultVoidHandler(result: Result<Void, KVTransactionError>) {
        switch result {
        case .failure(let error):
            self.errorHandler(error: error)
        case .success(_):
            return
        }
    }

    func errorHandler(error: KVTransactionError) {
        switch error {
        case .emptyKey:
            delegate?.presentError(error: .emptyKey)
        case .keyNotFound:
            delegate?.presentError(error: .keyNotFound)
        case .emptyValue:
            delegate?.presentError(error: .emptyValue)
        }
    }
}
