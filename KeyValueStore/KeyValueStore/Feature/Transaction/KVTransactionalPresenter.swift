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
    func execute(freeForm: String)
    func clearAll()
}

class KVTransactionalPresenter: ObservableObject, KVTransactionalPresentable, KVTransactionalInteractableDelegate {
    
    @Published var response: String = ""
    
    enum ErrorConstants: String {
        case noTransaction = "no transaction"
        case keyNotFound = "key not set"
        case missingParameters = "missing parameters"
        case missingKey = "missing key"
        case noStore = "no store"
        case sintaxError = "sintax error"
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
        updateStackTrace(info: "> \(transaction.rawValue)")
    }
    
    func execute(method: SelectedMethod, key: String = "", value: String = "") {
        switch method {
        case .SET:
            let command = "> \(method.rawValue) \(key.lowercased()) \(value.lowercased())"
            updateStackTrace(info: command)
            interactor.set(key: key.lowercased(), value: value.lowercased())
        case .GET:
            let command = "> \(method.rawValue) \(key.lowercased())"
            updateStackTrace(info: command)
            interactor.get(key: key.lowercased())
        case .DELETE:
            let command = "> \(method.rawValue) \(key.lowercased())"
            updateStackTrace(info: command)
            interactor.delete(key: key.lowercased())
        case .COUNT:
            let command = "> \(method.rawValue) \(value.lowercased())"
            updateStackTrace(info: command)
            interactor.count(value: value.lowercased())
        default:
            break
        }
    }
    
    func execute(freeForm: String) {
        updateStackTrace(info: "> \(freeForm)")
        let inputs = freeForm.components(separatedBy: " ").map { $0.lowercased() }
        guard let command = inputs.first, inputs.count <= 3 else {
            self.response = ErrorConstants.sintaxError.rawValue
            return
        }
        if command == "set" {
            interactor.set(key: inputs[1], value: inputs[2])
        } else if inputs.count > 2 {
            self.response = ErrorConstants.sintaxError.rawValue
            return
        } else if command == "get" {
            interactor.get(key: inputs[1])
        } else if command == "count" {
            interactor.count(value: inputs[1])
        } else if command == "delete" {
            interactor.delete(key: inputs[1])
        }
    }
    
    func clearAll() {
        interactor.clearAll()
        self.response = ""
    }
    
    // MARK: - KVTransactionalInteractableDelegate
    
    func presentSuccess(response: String) {
        updateStackTrace(info: response)
    }
    
    func presentError(error: TransactionErrorReason) {
        switch error {
        case .noTransaction:
            updateStackTrace(info: ErrorConstants.noTransaction.rawValue)
        case .keyNotFound:
            updateStackTrace(info: ErrorConstants.keyNotFound.rawValue)
        case .emptyParameters, .emptyValue:
            updateStackTrace(info: ErrorConstants.missingParameters.rawValue)
        case .emptyKey:
            updateStackTrace(info: ErrorConstants.missingKey.rawValue)
        case .noStore:
            updateStackTrace(info: ErrorConstants.noStore.rawValue)
        case .unknown:
            updateStackTrace(info: ErrorConstants.unknown.rawValue)
        }
    }
    
    // MARK: - Private Methods
    
    private func updateStackTrace(info: String) {
        self.response += "\n\(info)"
    }
}
