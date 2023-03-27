//
//  TransactionalPresenter.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 27/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

class KVTransactionalPresenter: KVTransactionalPresentable {
    
    private var interactor: KVTransactionalInteractable
    
    init(interactor: KVTransactionalInteractable) {
        self.interactor = interactor
    }
    
    // MARK: - KVTransactionalPresentable
    
    func presentSuccess(response: String) {
        
    }
    
    func presentError(error: TransactionErrorReason) {
        
    }
}
