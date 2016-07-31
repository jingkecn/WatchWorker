//
//  Event.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 17/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol EventJSExport: JSExport {
    
    var type: String { get }
    var target: EventTarget? { get }
    var currentTarget: EventTarget? { get }
    
    var composedPatch: Array<EventTarget> { get }
    
    var eventPhase: EventPhase { get }
    
    func stopPropagation()
    func stopImmediatePropagation()
    
    var bubbles: Bool { get }
    var cancelable: Bool { get }
    
    func preventDefault()
    
    var defaultPrevented: Bool { get }
    var composed: Bool { get }
    
    var isTrusted: Bool { get }
    var timeStamp: NSTimeInterval { get }
    
    func initEvent(type: String, _ bubbles: Bool, _ cancelable: Bool)
    
}

class Event: JSClassDelegate {
    
    var type: String
    var target: EventTarget?
    var currentTarget: EventTarget?
    var bubbles: Bool
    var cancelable: Bool
    var timeStamp: NSTimeInterval
    
    var isTrusted: Bool = false
    var defaultPrevented: Bool = false
    var composed: Bool = false
    var isInitialized: Bool = false
    
    var composedPatch: Array<EventTarget> = Array<EventTarget>()
    
    var propagationStopped: Bool = false
    var immediatePropagationStopped: Bool = false
    
    var dispatched: Bool { return self.target != nil }
    var eventPhase: EventPhase = .NONE
    
    init(context: ScriptContext, type: String, withEventInit initializer: EventInit) {
        self.isInitialized = true
        self.type = type
        self.bubbles = initializer.bubbles
        self.cancelable = initializer.cancelable
        self.composed = initializer.composed
        self.timeStamp = NSDate().timeIntervalSince1970 * 1000
        super.init(context: context)
    }
    
    func attatchEventTarget(target: EventTarget) {
        self.target = target
    }
    
//    func attatchEventTarget(target: EventTargetDelegate) {
//        self.target = target
//    }
    
}

extension Event: EventJSExport {
    
    func stopPropagation() {
        self.propagationStopped = true
    }
    func stopImmediatePropagation() {
        self.immediatePropagationStopped = true
    }
    
    func preventDefault() {
        self.defaultPrevented = true
    }
    
    func initEvent(type: String, _ bubbles: Bool, _ cancelable: Bool) {
//        guard !self.dispatched else { return }
//        self.isInitialized = true
//        self.propagationStopped = false
//        self.immediatePropagationStopped = false
//        self.defaultPrevented = false
//        self.isTrusted = false
//        self.type = type
//        self.bubbles = bubbles
//        self.cancelable = cancelable
    }
    
}

extension Event {
    
//    class func create(context: ScriptContext, type: String, bubbles: Bool, cancelable: Bool) -> Event {
//        return Event(context: context, type: type, withEventInit: EventInit.create(context, initDict: ["bubbles": bubbles, "cancelable": cancelable]))
//    }
    
    class func create(context: ScriptContext, type: String, initValue: JSValue) -> Event {
        return Event(context: context, type: type, withEventInit: EventInit.create(context, initValue: initValue))
    }
    
    class func create(context: ScriptContext, type: String, initDict: Dictionary<String, AnyObject>) -> Event {
        return Event(context: context, type: type, withEventInit: EventInit.create(context, initDict: initDict))
    }
    
}

extension Event {
    
    override var debugInfo: Dictionary<String, AnyObject> {
        var debugInfo = super.debugInfo
        debugInfo["type"] = self.type
        debugInfo["target"] = self.target
        return debugInfo
    }
    
}

@objc enum EventPhase: Int {
    case NONE = 0
    case CAPTURING_PHASE
    case AT_TARGET
    case BUBBLING_PHASE
}