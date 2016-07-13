//
//  MessageEvent.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol MessageEventJSExport: JSExport {
    
    var data: String { get }
    var origin: String { get }
    var lastEventId: String { get }
    var source: EventTarget? { get }
    var ports: Array<MessagePort> { get }
    
    func initMessageEvent(type: String, _ bubbles: Bool, _ cancelable: Bool, _ data: String
    , _ origin: String, _ lastEventId: String, _ source: EventTarget?, _ ports: Array<MessagePort>)
    
}

class MessageEvent: Event, MessageEventJSExport {
    
    var origin: String
    var lastEventId: String
    var source: EventTarget?
    var isValidSource: Bool { return self.source != nil }
    var ports: Array<MessagePort>
    var data: String
    
    init(context: ScriptContext, type: String, withMessageEventInit initializer: MessageEventInit) {
        self.data = initializer.data
        self.origin = initializer.origin
        self.lastEventId = initializer.lastEventId
        self.source = initializer.source
        self.ports = initializer.ports
        super.init(context: context, type: type, withEventInit: initializer)
    }
    
    func initMessageEvent(type: String, _ bubbles: Bool, _ cancelable: Bool, _ data: String
        , _ origin: String, _ lastEventId: String, _ source: EventTarget? = nil, _ ports: Array<MessagePort>) {
//        super.initEvent(type, bubbles, cancelable)
//        guard !self.dispatched else { return }
//        self.data = data
//        self.origin = origin
//        self.lastEventId = lastEventId
//        self.source = source
//        self.ports = ports
    }
    
}

extension MessageEvent {
    
    func registerData(data: String) {
        self.data = data
    }
    
    func registerPort(port: MessagePort) {
        var ports = self.ports ?? Array<MessagePort>()
        ports.append(port)
        self.ports = ports
    }
    
}

extension MessageEvent {
    
    override class func create(context: ScriptContext, type: String, initValue: JSValue) -> MessageEvent {
        return MessageEvent(context: context, type: type, withMessageEventInit: MessageEventInit.create(context, initValue: initValue))
    }
    
    override class func create(context: ScriptContext, type: String, initDict: Dictionary<String, AnyObject>) -> MessageEvent {
        return MessageEvent(context: context, type: type, withMessageEventInit: MessageEventInit.create(context, initDict: initDict))
    }
    
}

extension MessageEvent {
    
    override var debugInfo: Dictionary<String, AnyObject> {
        var debugInfo = super.debugInfo
        debugInfo["data"] = self.data
        debugInfo["ports"] = self.ports.map({ return $0.debugInfo })
        return debugInfo
    }
    
}