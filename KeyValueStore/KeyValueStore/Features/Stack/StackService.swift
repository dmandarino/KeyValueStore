//
//  StackService.swift
//  KeyValueStore
//
//  Created by Douglas Mandarino on 23/03/23.
//  Copyright © 2023 Douglas Mandarino. All rights reserved.
//

import Foundation

public protocol KVStackServicing {
    func push(action: Action, key: String)
    @discardableResult func pop() -> (Action, key: String)?
}

public struct KVStackService: KVStackServicing {
    
    public func push(action: Action, key: String) {
        let node = Node(action: action, key: key)
        guard !KVStack.items.isEmpty else {
            KVStack.items.append([node])
            return
        }
        updateStack(with: node)
    }
    
    public func pop() -> (Action, key: String)? {
        guard var topStack = KVStack.items.last, let topNode = topStack.last else { return nil }
        topStack.removeLast()
        KVStack.items.removeLast()
        if !topStack.isEmpty {
            KVStack.items.append(topStack)
        }
        return (topNode.action, topNode.key)
    }
    
    private func updateStack(with node: Node) {
        guard var top = KVStack.items.last else { return }
        KVStack.items.removeLast()
        top.append(node)
        KVStack.items.append(top)
    }
}
