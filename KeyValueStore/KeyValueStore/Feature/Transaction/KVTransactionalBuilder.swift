//
//  KVTransactionalBuilder.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

//protocol KVTransacionalDependencies {
//    var storeService: KVTransactionServicing { get }
//    var stackService: KVStackWorkable { get }
//}
//
//protocol KVTransactionalBuildable {
//    func build() -> KVTransactInteractable
//}
//
//struct KVTransactionalBuilder: KVTransacionalDependencies {
//    
//    var storeService: KVTransactionServicing {
//        KVTransactionBuilder.build()
//    }
//    
//    var stackService: KVStackWorkable {
//        KVStackWorker()
//    }
//    
//    func build() -> KVTransactInteractable {
//        let interactor = KVTransactionalInteractor(storeService: storeService, stackService: stackService)
//        return interactor
//    }
//}
