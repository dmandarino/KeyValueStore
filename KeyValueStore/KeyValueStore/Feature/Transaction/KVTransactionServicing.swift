//
//  KVTransactionServicing.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

/*
 KVTransactionServicing is responsible for accessing Store. We're assuming is in memory, but if it was another SDK or local Storage,
 it's unlikely that we change this protocol to protect our application.
 */
public protocol KVTransactionServicing {
    @discardableResult func set(key: String, value: String) -> Result<Void, KVTransactionError>
    @discardableResult func delete(key: String) -> Result<Void, KVTransactionError>
    func get(key: String) -> Result<String, KVTransactionError>
    func count(value: String) -> Result<Int, KVTransactionError>
}
