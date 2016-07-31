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
    
    func createMessageChannel() -> MessageChannel {
        return MessageChannel.create(self)
    }
    
    func createAbstractWorker(scriptURL: String) -> AbstractWorker {
        return AbstractWorker.create(self, scriptURL: scriptURL)
    }
    
    func createWorker(scriptURL: String) -> Worker {
        return Worker.create(self, scriptURL: scriptURL)
    }
    
//    func createWatchWorker(scriptURL: String) -> WatchWorker {
//        return WatchWorker.create(self, scriptURL: scriptURL)
//    }
    
    func createSharedWorker(scriptURL: String, _ name: String = "") -> SharedWorker {
        return SharedWorker.create(self, scriptURL: scriptURL, name: name)
    }
    
    
    func createSharedWatchWorker(scriptURL: String, _ name: String = "") -> SharedWatchWorker {
        return SharedWatchWorker.create(self, scriptURL: scriptURL, name: name)
    }
}

@objc protocol ScriptContextJSExport: JSExport {
    
//    var scope: ScriptContext { get }
    
    func createEvent(type: String, _ eventInit: JSValue) -> Event
    func createErrorEvent(type: String, _ eventInit: JSValue) -> ErrorEvent
    func createMessageEvent(type: String, _ eventInit: JSValue) -> MessageEvent
    func createEventTarget() -> EventTarget
    func createMessagePort() -> MessagePort
    func createMessageChannel() -> MessageChannel
    func createWorker(scriptURL: String) -> Worker
//    func createWatchWorker(scriptURL: String) -> WatchWorker
    func createSharedWorker(scriptURL: String, _ name: String) -> SharedWorker
    func createSharedWatchWorker(scriptURL: String, _ name: String) -> SharedWatchWorker
//    func createWCSharedWorker(scriptURL: String, _ name: String, _ options: JSValue) -> WCSharedWorker
    
}