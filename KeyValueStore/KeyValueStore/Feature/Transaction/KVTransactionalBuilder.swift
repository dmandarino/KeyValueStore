//
//  KVTransactionalBuilder.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

typealias KVTransacionalModule = KVTransactionalPresentable

protocol KVTransacionalDependencies {
    var kvStore: KVStore { get set }
    var kvStack: KVStack { get }
}

protocol KVTransactionalBuildable: KVTransacionalDependencies {
    func build() -> KVTransactionalPresenter
}

class KVTransactionalBuilder: KVTransactionalBuildable {
    
    var kvStore: KVStore = KVStoreBuilder.build()
    
    var kvStack: KVStack {
        KVStackBuilder.build()
    }
    
    func build() -> KVTransactionalPresenter {
        let interactor = KVTransactionalInteractor(storeWorker: kvStore, stackWorker: kvStack)
        let presenter = KVTransactionalPresenter(interactor: interactor)
        kvStore.delegate = interactor
        interactor.delegate = presenter
        return presenter
    }
}
