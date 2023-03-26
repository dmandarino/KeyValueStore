//
//  KVTransactionError.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

public enum KVTransactionError: Error {
    case keyNotFound
    case emptyKey
    case emptyValue
}
