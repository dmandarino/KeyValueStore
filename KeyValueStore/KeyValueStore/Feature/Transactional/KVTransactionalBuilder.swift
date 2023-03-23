//
//  KVTransactionalBuilder.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVTransacionalDependencies {
    var storeService: KVStoreServicing { get }
    var stackService: KVStackServicing { get }
}

protocol KVTransactionalBuildable {
    func build() -> KVTransactInteractable
}

struct KVTransactionalBuilder: KVTransacionalDependencies {
    
    var storeService: KVStoreServicing {
        KVStoreBuilder.build()
    }
    
    var stackService: KVStackServicing {
        KVStackService()
    }
    
    func build() -> KVTransactInteractable {
        let interactor = KVTransactionalInteractor(storeService: storeService, stackService: stackService)
        return interactor
    }
}
