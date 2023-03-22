//
//  KVStoreStatus.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

public enum KVStoreError: Error {
    case keyNotFound
    case emptyKey
    case emptyValue
}
