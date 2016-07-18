//
//  Stack.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 17/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation

struct Stack<Element> {
    var items: Array<Element>
    var isEmpty: Bool {
        return self.items.isEmpty
    }
    var topItem: Element? {
        return self.isEmpty ? nil : self.items[self.items.count - 1]
    }
    init(items: Array<Element> = Array<Element>()) {
        self.items = items
    }
    mutating func push(item: Element) {
        self.items.append(item)
    }
    mutating func pop() -> Element? {
        return self.isEmpty ? nil : self.items.removeLast()
    }
    static func create() -> Stack<Element> {
        return Stack<Element>()
    }
}