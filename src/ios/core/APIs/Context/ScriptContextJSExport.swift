//
//  ScriptContextJSExport.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

extension ScriptContext: ScriptContextJSExport {
    
    var scope: ScriptContext {
        return self
    }
    
    func createEvent(type: String, _ eventInit: JSValue) -> Event {
        return Event.create(self, type: type, initValue: eventInit)
    }
    
    func createErrorEvent(type: String, _ eventInit: JSValue) -> ErrorEvent {
        return ErrorEvent.create(self, type: type, initValue: eventInit)
    }
    
    func createMessageEvent(type: String, _ eventInit: JSValue) -> MessageEvent {
        return MessageEvent.create(self, type: type, initValue: eventInit)
    }
    
    func createEventTarget() -> EventTarget {
        return EventTarget.create(self)
    }
    
    func createMessagePort() -> MessagePort {
        return MessagePort.create(self)
    }
    
    func createWCMessagePort() -> WCMessagePort {
        return WCMessagePort.create(self)
    }
    
    func createMessageChannel() -> MessageChannel {
        return MessageChannel.create(self)
    }
    
    func createWCMessageChannel() -> WCMessageChannel {
        return WCMessageChannel.create(self)
    }
    
    func createSharedWorker(scriptURL: String, _ name: String = "", _ options: JSValue) -> SharedWorker {
        let validName = name == "undefined" ? "" : name
        return SharedWorker.create(self, scriptURL: scriptURL, name: validName, options: options)
    }
    
    func createWCSharedWorker(scriptURL: String, _ name: String = "", _ options: JSValue) -> WCSharedWorker {
        return WCSharedWorker.create(self, scriptURL: scriptURL, name: name, options: options)
    }
}

@objc protocol ScriptContextJSExport: JSExport {
    
    var scope: ScriptContext { get }
    
    func createEvent(type: String, _ eventInit: JSValue) -> Event
    func createErrorEvent(type: String, _ eventInit: JSValue) -> ErrorEvent
    func createMessageEvent(type: String, _ eventInit: JSValue) -> MessageEvent
    func createEventTarget() -> EventTarget
    func createMessagePort() -> MessagePort
    func createWCMessagePort() -> WCMessagePort
    func createMessageChannel() -> MessageChannel
    func createWCMessageChannel() -> WCMessageChannel
    func createSharedWorker(scriptURL: String, _ name: String, _ options: JSValue) -> SharedWorker
    func createWCSharedWorker(scriptURL: String, _ name: String, _ options: JSValue) -> WCSharedWorker
    
}