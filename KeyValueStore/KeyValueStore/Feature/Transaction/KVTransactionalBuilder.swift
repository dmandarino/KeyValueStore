//
//  KVTransactionalBuilder.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVTransacionalDependencies {
    var kvStore: KVStore { get }
    var kvStack: KVStack { get }
}

protocol KVTransactionalBuildable: KVTransacionalDependencies {
    func build() -> KVTransactionalInteractable
}

struct KVTransactionalBuilder: KVTransactionalBuildable {
    
    var kvStore: KVStore {
        KVStoreBuilder.build()
    }
    
    var kvStack: KVStack {
        KVStackBuilder.build()
    }
    
    func build() -> KVTransactionalInteractable {
        let interactor = KVTransactionalInteractor(storeWorker: kvStore, stackWorker: kvStack)
        return interactor
    }
}
