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
    
    var connected: Bool {
        return !self.entangledPorts.isEmpty
    }
    
    var entangledPorts = Set<MessagePort>()
    
    var isEntangled: Bool {
        return !self.closed && !self.isNeutered
    }
    var isNeutered: Bool {
        return self.entangledPorts.isEmpty
    }
    
    override init(context: ScriptContext) {
        self.closed = false
        self.started = false
        super.init(context: context)
        self.addEventListener("message", listener: EventListener.create(withHandler: self.onMessage))
//        self.context.ports.insert(self)
    }
    
    deinit {
        self.close()
    }
    
}

extension MessagePort: MessagePortJSExport {
    
    func postMessage(message: String) {
        guard self.started else { return }
        print("[\(self.className)] about to send message to \(self.entangledPorts)")
        self.entangledPorts.forEach({ $0.dispatchMessage(message) })
    }
    
    func start() {
        print("[\(self.className)] Starting message port {\(self)}!")
        guard self.isEntangled else { return }
        guard !self.started else { return }
        self.started = true
    }
    
    func close() {
        print("[\(self.className)] Closing message port {\(self)}!")
        self.entangledPorts.removeAll()
//        self.context.ports.remove(self)
        self.context.destroyContext()
        self.closed = true
    }
    
    func debug() {
        print("[\(self.className)] Debug info \n\(self.debugInfo)")
    }
    
}

extension MessagePort {
    
    func entangle(port: MessagePort) {
        guard port != self else { return }
        if self.context == port.context { self.disentangle() }
        guard !self.entangledPorts.contains(port) else { return }
        self.entangledPorts.insert(port)
    }
    
    func disentangle(port: MessagePort? = nil) {
        guard let port = port else { self.entangledPorts.removeAll(); return }
        self.entangledPorts.remove(port)
    }
    
    func dispatchMessage(message: String) {
        let event = MessageEvent.create(self.context, type: "message", initDict: [ "source": self, "data": message ])
        self.dispatchEvent(event)
    }
    
}

extension MessagePort {
    
    func onMessage(event: Event) {
        guard let event = event as? MessageEvent else { return }
        guard let jsEvent = event.thisJSValue else { return }
        // Invoke [onmessage] function in execution context
        guard let this = self.thisJSValue else { return }
        //        this.invokeMethod("onmessage", withArguments: [jsEvent])
        guard let onmessage = this.objectForKeyedSubscript("onmessage") where !onmessage.isUndefined && !onmessage.isNull else { return }
        onmessage.callWithArguments([jsEvent])
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
        debugInfo["entanglePorts"] = self.entangledPorts.map({ return $0.debugInfo })
        return debugInfo
    }
    
}

