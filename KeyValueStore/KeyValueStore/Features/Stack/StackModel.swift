//
//  Stack.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

protocol KVStacking {
    static var items: [[Node]] { get set }
}

final class KVStack: KVStacking {
    
    static var items: [[Node]] = []
    
    private init() {}
}
