//
//  StackBuilder.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 27/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

typealias KVStack = KVStackWorkable

protocol KVStackBuildable {
    static func build() -> KVStack
}

struct KVStackBuilder: KVStackBuildable {

    static func build() -> KVStack {
        KVStackWorker()
    }
}
