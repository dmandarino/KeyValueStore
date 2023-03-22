//
//  KVStoreBuilder.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

public protocol KVStoreBuildable {
    static func build() -> KVStoreServicing
}

public final class KVStoreBuilder: KVStoreBuildable {
    
    public static func build() -> KVStoreServicing {
        let store = KVStore()
        let service = KVStoreService(store: store)
        return service
    }
}
