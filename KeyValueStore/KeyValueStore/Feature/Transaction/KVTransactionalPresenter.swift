//
//  TransactionalPresenter.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 27/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVTransactionalPresentable: ObservableObject {
    var response: String { get }
    func execute(transaction: SelectedMethod)
    func execute(method: SelectedMethod, key: String, value: String)
}

class KVTransactionalPresenter: ObservableObject, KVTransactionalPresentable, KVTransactionalInteractableDelegate {
    
    @Published var response: String = ""
    
    enum ErrorConstants: String {
        case noTransaction = "no transaction"
        case keyNotFound = "key not set"
        case missingParameters = "missing parameters"
        case missingKey = "missing key"
        case noStore = "no store"
        case unknown = "unexpected error"
    }
    
    private var interactor: KVTransactionalInteractable
    
    init(interactor: KVTransactionalInteractable) {
        self.interactor = interactor
    }
    
    // MARK: - KVTransactionalPresentable
    
    func execute(transaction: SelectedMethod) {
        switch transaction {
        case .BEGIN:
            interactor.begin()
        case .COMMIT:
            interactor.commit()
        case .ROLLBACK:
            interactor.rollback()
        default:
            return
        }
    }
    
    func execute(method: SelectedMethod, key: String = "", value: String = "") {
        switch method {
        case .SET:
            interactor.set(key: key, value: value)
        case .GET:
            interactor.get(key: key)
        case .DELETE:
            interactor.delete(key: key)
        case .COUNT:
            interactor.count(value: key)
        default:
            break
        }
    }
    
    // MARK: - KVTransactionalInteractableDelegate
    
    func presentSuccess(response: String) {
        self.response = response
    }
    
    func presentError(error: TransactionErrorReason) {
        switch error {
        case .noTransaction:
            self.response = ErrorConstants.noTransaction.rawValue
        case .keyNotFound:
            self.response = ErrorConstants.keyNotFound.rawValue
        case .emptyParameters, .emptyValue:
            self.response = ErrorConstants.missingParameters.rawValue
        case .emptyKey:
            self.response = ErrorConstants.missingKey.rawValue
        case .noStore:
            self.response = ErrorConstants.noStore.rawValue
        case .unknown:
            self.response = ErrorConstants.unknown.rawValue
        }
    }
}
