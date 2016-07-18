//
//  WCMessagePort.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

class WCMessagePort: MessagePort {
    
    let service = WCMessageService.defaultService
    
    override func registerEvents() {
        super.registerEvents()
        let watchConnectedEvent = MessageEvent.create(context, type: "watchconnected", initDict: ["source": self, "ports": [self]])
        let watchDisconnectedEvent = MessageEvent.create(context, type: "watchdisconnected", initDict: ["source": self, "ports": [self]])
        let errorEvent = ErrorEvent.create(context, type: "error", initDict: [:])
        self.registerEvent(watchConnectedEvent)
        self.registerEvent(watchDisconnectedEvent)
        self.registerEvent(errorEvent)
    }
    
}

extension WCMessagePort {
    
    override func start() {
        // TODO
        self.service.startService(onSuccess: {
            session in
            guard let event = self.getEventByType("watchconnected") as? MessageEvent else { return }
            event.registerData("Session status: \(session.activationState.rawValue)")
            self.onWatchConnected(event)
        }, onError: {
            error in
            guard let event = self.getEventByType("error") as? ErrorEvent else { return }
            event.registerMessage(error)
            self.onError(event)
        })
        self.service.addMessageListener(self.postMessage)
        super.start()
    }
    
}

extension WCMessagePort {
    
    func onWatchConnected(event: MessageEvent) {
        self.dispatchEvent(event)
        guard let jsEvent = event.thisJSValue else { return }
        // Invoke global [onwatchconnected] function
        guard let context = self.context.executionContext else { return }
        if context.globalObject.hasProperty("watchconnected") {
            context.globalObject.invokeMethod("watchconnected", withArguments: [jsEvent])
        }
        // Invoke [onwatchconnected] function
        guard let thisJSValue = self.thisJSValue else { return }
        if thisJSValue.hasProperty("onwatchconnected") {
            thisJSValue.invokeMethod("onwatchconnected", withArguments: [jsEvent])
        }
    }
    
    func onWatchDisconnected(event: MessageEvent) {
        self.dispatchEvent(event)
        guard let jsEvent = event.thisJSValue else { return }
        // Invoke global [onwatchconnected] function
        guard let context = self.context.executionContext else { return }
        if context.globalObject.hasProperty("watchdisconnected") {
            context.globalObject.invokeMethod("watchdisconnected", withArguments: [jsEvent])
        }
        // Invoke [onwatchconnected] function
        guard let thisJSValue = self.thisJSValue else { return }
        if thisJSValue.hasProperty("onwatchdisconnected") {
            thisJSValue.invokeMethod("onwatchdisconnected", withArguments: [jsEvent])
        }
    }
    
    func onError(event: ErrorEvent) {
        dispatchEvent(event)
        guard let jsEvent = event.thisJSValue else { return }
        // Invoke global [onwatchconnected] function
        guard let context = self.context.executionContext else { return }
        if context.globalObject.hasProperty("error") {
            context.globalObject.invokeMethod("error", withArguments: [jsEvent])
        }
        // Invoke [onwatchconnected] function
        guard let thisJSValue = self.thisJSValue else { return }
        if thisJSValue.hasProperty("error") {
            thisJSValue.invokeMethod("error", withArguments: [jsEvent])
        }
    }
    
    override func onMessage(event: MessageEvent) {
        super.onMessage(event)
        let message = event.data
        self.service.sendMessage([PHONE_MESSAGE: message])
    }
    
}

extension WCMessagePort {
    
    override class func create(context: ScriptContext) -> WCMessagePort {
        return WCMessagePort(context: context)
    }
    
}

