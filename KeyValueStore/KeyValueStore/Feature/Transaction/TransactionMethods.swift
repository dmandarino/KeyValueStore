//
//  TransactionMethods.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 24/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

public enum TransactionalMethod: String {
    case BEGIN
    case COMMIT
    case ROLLBACK
}

public enum SelectedMethod {
    case DELETE
    case SET
    case GET
    case COUNT
}
