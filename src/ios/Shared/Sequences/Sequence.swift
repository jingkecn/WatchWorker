//
//  Sequence.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 17/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation

struct Sequence<Element> {
    
    var items = Array<Element>()
    
    var isEmpty: Bool {
        return self.items.isEmpty
    }
    
    var first: Element? {
        return self.isEmpty ? nil : self.items[0]
    }
    
    var last: Element? {
        return self.isEmpty ? nil : self.items[self.items.count - 1]
    }
    
}