//
//  Queue.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 17/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation

struct Queue<Element> {
    var items: Array<Element>
    var isEmpty: Bool {
        return self.items.isEmpty
    }
    var frontItem: Element? {
        return self.isEmpty ? nil : self.items[0]
    }
    init(items: Array<Element> = Array<Element>()) {
        self.items = items
    }
    mutating func enqueue(item: Element) {
        self.items.append(item)
    }
    mutating func dequeue() -> Element? {
        return self.isEmpty ? nil : self.items.removeAtIndex(0)
    }
    static func create() -> Queue<Element> {
        return Queue<Element>()
    }
}
