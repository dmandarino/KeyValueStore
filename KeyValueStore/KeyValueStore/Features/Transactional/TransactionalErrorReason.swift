//
//  TransactionalErrorReason.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

enum TransactionalErrorReason {
    case keyNotFound
    case emptyKey
    case emptyValue
    case noTransaction
}
