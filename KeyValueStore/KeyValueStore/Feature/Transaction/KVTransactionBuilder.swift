//
//  KVStoreBuilder.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

public protocol KVStoreBuildable {
    static func build() -> KVTransactionServicing
}

public final class KVTransactionBuilder: KVStoreBuildable {
    
    public static func build() -> KVTransactionServicing {
        let store = KVStore()
        let service = KVTransactionService(store: store)
        return service
    }
}
