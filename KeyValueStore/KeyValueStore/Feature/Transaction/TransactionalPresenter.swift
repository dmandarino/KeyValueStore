//
//  TransactionalPresenter.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 27/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVTransactionalPresentable {
    
}

class KVTransactionalPresenter: KVTransactionalInteractableDelegate {
    
    private var interactor: KVTransactionalInteractable
    
    init(interactor: KVTransactionalInteractable) {
        self.interactor = interactor
    }
    
    // MARK: - KVTransactionalInteractableDelegate
    
    func presentSuccess(response: String) {
        
    }
    
    func presentError(error: TransactionErrorReason) {
        
    }
}
