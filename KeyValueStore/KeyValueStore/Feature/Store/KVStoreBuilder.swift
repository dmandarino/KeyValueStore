//
//  KVStoreBuilder.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 27/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

typealias KVStore = KVStoreWorkable

protocol KVStoreBuildable {
    static func build() -> KVStore
}

struct KVStoreBuilder: KVStoreBuildable {

    private static var store: KVStoring {
        KVStoreModel()
    }
    
    static func build() -> KVStore {
        let service = KVStoreService(store: store)
        let worker = KVStoreWorker(service: service)
        return worker
    }
}
