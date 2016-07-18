//
//  EventListenerOptions.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 27/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

class EventListenerOptions: NSObject {
    
    let capture: Bool
    
    init(capture: Bool? = nil) {
        self.capture = capture ?? false
    }
    
    convenience init?(options: JSValue?) {
        guard let options = options where !options.isUndefined && !options.isNull else { return nil }
        if options.isBoolean {
            self.init(capture: options.toBool())
            return
        }
        let captureValue = options.objectForKeyedSubscript("capture")
        let capture: Bool? = captureValue.isBoolean ? captureValue.toBool() : nil
        self.init(capture: capture)
    }
    
}

class AddEventListenerOptions: EventListenerOptions {
    
    let passive: Bool
    let once: Bool
    
    init(capture: Bool? = nil, passive: Bool? = nil, once: Bool? = nil) {
        self.passive = passive ?? false
        self.once = once ?? false
        super.init(capture: capture)
    }
    
    convenience init?(options: JSValue?) {
        guard let options = options where !options.isUndefined && !options.isNull else { return nil }
        if options.isBoolean {
            self.init(capture: options.toBool())
            return
        }
        let captureValue = options.objectForKeyedSubscript("capture")
        let capture: Bool? = captureValue.isBoolean ? captureValue.toBool() : nil
        let passiveValue = options.objectForKeyedSubscript("passive")
        let passive: Bool? = passiveValue.isBoolean ? passiveValue.toBool() : nil
        let onceValue = options.objectForKeyedSubscript("once")
        let once: Bool?  = onceValue.isBoolean ? onceValue.toBool() : nil
        self.init(capture: capture, passive: passive, once: once)
    }
    
}