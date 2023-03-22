//
//  StringExtension.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 22/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

extension String {
    public var isNotEmpty: Bool {
        return !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
