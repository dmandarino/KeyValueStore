//
//  Stack.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVStacking {
    var items: [[KVTransactional]] { get }
}

final class KVStackModel: KVStacking {
    
    var items: [[KVTransactional]]
    
    init(items: [[KVTransactional]] = []) {
        self.items = items
    }
}
