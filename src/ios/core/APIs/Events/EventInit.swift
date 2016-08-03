//
//  EventInit.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol EventInitJSExport: JSExport {
    
    var bubbles: Bool { get }
    var cancelable: Bool { get }
    var composed: Bool { get }
    
}

class EventInit: JSClassDelegate, EventInitJSExport {
    
    let bubbles: Bool
    let cancelable: Bool
    let composed: Bool
    
    init(context: ScriptContext, bubbles: Bool? = nil, cancelable: Bool? = nil, composed: Bool? = nil) {
        self.bubbles = bubbles ?? false
        self.cancelable = cancelable ?? false
        self.composed = composed ?? false
        super.init(context: context)
    }
    
    convenience init(context: ScriptContext, initValue: JSValue) {
        guard !initValue.isUndefined else {
            self.init(context: context, bubbles: false, cancelable: false, composed: false)
            return
        }
        let bubblesValue = initValue.objectForKeyedSubscript("bubbles")
        let bubbles = bubblesValue.isBoolean ? bubblesValue.toBool() : false
        let cancelableValue = initValue.objectForKeyedSubscript("cancelable")
        let cancelable = cancelableValue.isBoolean ? cancelableValue.toBool() : false
        let composedValue = initValue.objectForKeyedSubscript("composed")
        let composed = composedValue.isBoolean ? composedValue.toBool() : false
        self.init(context: context, bubbles: bubbles, cancelable: cancelable, composed: composed)
    }
    
    convenience init(context: ScriptContext, initDict: Dictionary<String, AnyObject>) {
        self.init(
            context: context,
            bubbles: initDict["bubbles"] as? Bool,
            cancelable: initDict["cancelable"] as? Bool,
            composed: initDict["composed"] as? Bool
        )
    }
    
}

extension EventInit {
    
    class func create(context: ScriptContext, initValue: JSValue) -> EventInit {
        return EventInit(context: context, initValue: initValue)
    }
    
    class func create(context: ScriptContext, initDict: Dictionary<String, AnyObject>) -> EventInit {
        return EventInit(context: context, initDict: initDict)
    }
    
}