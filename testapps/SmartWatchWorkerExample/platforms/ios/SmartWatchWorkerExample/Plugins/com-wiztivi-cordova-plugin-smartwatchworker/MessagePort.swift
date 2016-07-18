//
//  MessagePort.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 22/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore
import WatchConnectivity

@objc protocol MessagePortJSExport: JSExport {
    
    func postMessage(message: String)
    
    func start()
    func close()
    
}

class MessagePort: EventTarget {
    
    var started: Bool
    var closed: Bool
    
    var connected = false
    
    var remote: MessagePort? {
        didSet {
            guard self.remote != nil else { return }
            print("[\(self.className)] This port is connected: \n\(self.debugInfo)")
            guard let event = self.getEventByType("connect") as? MessageEvent where !self.connected else { return }
            self.onConnect(event)
        }
    }
    
    var isEntangled: Bool {
        return !self.closed && !self.isNeutered
    }
    var isNeutered: Bool {
        return self.remote == nil
    }
    
    var messageQueue = Queue<String>() {
        didSet {
            while !self.messageQueue.isEmpty {
                if let message = self.messageQueue.dequeue() {
                    if let event = self.getEventByType("message") as? MessageEvent {
                        event.registerData(message)
                        self.onMessage(event)
                    }
                }
            }
        }
    }
    
    override init(context: ScriptContext) {
        self.closed = false
        self.started = false
        super.init(context: context)
        self.context.registerMessagePort(self)
        self.registerEvents()
    }
    
    deinit {
        self.close()
    }
    
    func registerEvents() {
        let connectEvent = MessageEvent.create(self.context, type: "connect", initDict: [
            "source": self,
            "ports": [self]
        ])
        let messageEvent = MessageEvent.create(self.context, type: "message", initDict: [
            "source": self
        ])
        self.registerEvent(connectEvent)
        self.registerEvent(messageEvent)
    }
    
}

extension MessagePort: MessagePortJSExport {
    
    func postMessage(message: String) {
        print("[\(self)] posting message {\(message)} from \(self.context) to \(self.remote?.context)")
        guard self.started else { return }
        guard let remote = self.remote else { return }
        remote.messageQueue.enqueue(message)
    }
    
    func start() {
        print("[\(self.className)] Starting message port {\(self)}!")
        guard self.isEntangled else { return }
        guard !self.started else { return }
        self.started = true
    }
    
    func close() {
        print("[\(self.className)] Closing message port {\(self)}!")
        self.remote?.close()
        self.remote = nil
        self.closed = true
        self.context.unregisterMessagePort(self)
        self.context.destroyContext()
    }
    
    func debug() {
        print("[\(self.className)] Debug info \n\(self.debugInfo)")
    }
    
}

extension MessagePort {
    
    func entangleRemotePort(port: MessagePort) {
        if !self.isNeutered { self.disentangleRemotePort() }
        print("[\(self.className)] Entangling remote port: \(port)")
        self.remote = port
    }
    
    func disentangleRemotePort() -> MessagePort? {
        let remotePort: MessagePort? = self.remote
        self.remote = nil
        return remotePort
    }
    
    func onConnect(event: MessageEvent) {
        guard let jsEvent = event.thisJSValue else { return }
        guard let context = self.context.executionContext else { return }
        if context.globalObject.hasProperty("onconnect") {
            context.globalObject.invokeMethod("onconnect", withArguments: [jsEvent])
        }
        self.connected = true
    }
    
    func onMessage(event: MessageEvent) {
        print("==================== [\(self.className)] Start handling message ====================")
        print("1. message event = \(event.debugInfo)")
        guard let jsEvent = event.thisJSValue else { return }
        print("2. event = \(jsEvent), event.instance = \(jsEvent.objectForKeyedSubscript("instance"))")
        // About to dispatch message event
        if self.started {
            self.dispatchEvent(event)
            print("3. Message event has been dispatched!")
        }
        // Invoke [onmessage] function in execution context
        guard let this = self.thisJSValue else { return }
        print("4. this = \(this), this.instane = \(this.objectForKeyedSubscript("instance"))")
        if this.hasProperty("onmessage") {
            print("5. Invoking [onmessage] handler with arguments: \(jsEvent.objectForKeyedSubscript("instance"))")
            this.invokeMethod("onmessage", withArguments: [jsEvent])
        }
        print("==================== [\(self.className)] End handling message ====================")
    }
    
}

extension MessagePort {
    
    override class func create(context: ScriptContext) -> MessagePort {
        return MessagePort(context: context)
    }
    
}

extension MessagePort {
    
    override var debugInfo: Dictionary<String, AnyObject> {
        var debugInfo = super.debugInfo
        debugInfo["started"] = self.started
        debugInfo["closed"] = self.closed
        debugInfo["isEntangle"] = self.isEntangled
        return debugInfo
    }
    
}

