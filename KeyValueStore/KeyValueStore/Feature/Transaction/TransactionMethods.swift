//
//  TransactionMethods.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 24/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

public enum SelectedMethod: String {
    case DELETE
    case SET
    case GET
    case COUNT
    case BEGIN
    case COMMIT
    case ROLLBACK
}
