//
//  TransactionalErrorReason.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

enum TransactionErrorReason {
    case keyNotFound
    case emptyKey
    case emptyValue
    case noStore
    case noTransaction
    case unknown
}

extension TransactionErrorReason {
    static func match(error: KVStoreError) -> TransactionErrorReason {
        switch error {
        case .emptyKey: return .emptyKey
        case .keyNotFound: return .keyNotFound
        case .emptyValue: return .emptyValue
        default: return .unknown
        }
    }
}
