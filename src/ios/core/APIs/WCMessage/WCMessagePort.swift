//
//  WCMessagePort.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import WatchConnectivity
import JavaScriptCore

class WCMessagePort: MessagePort, WCSessionDelegate {
    
    var session: WCSession? = {
        guard WCSession.isSupported() else { return nil }
        return WCSession.defaultSession()
    }()
    
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
    
    var isWatchReachable: Bool {
        return self.reachableSession != nil
    }
    
    override func start() {
        // TODO
        self.session?.delegate = self
        self.session?.activateSession()
        if self.context.isValid && self.reachableSession != nil {
            if let event = self.getEventByType("watchconnected") as? MessageEvent {
                self.onWatchConnected(event)
            }
        }
        super.start()
    }
    
    override func close() {
        // TODO
        self.session = nil
        if self.context.isValid {
            if let event = self.getEventByType("watchdisconnected") as? MessageEvent {
                self.onWatchDisconnected(event)
            }
        }
        super.close()
    }
    
}

extension WCMessagePort {
    
    func onWatchConnected(event: MessageEvent) {
//        guard let watchConnectedEvent = self.getEventByType("watchconnected") as? MessageEvent else { return }
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
//        guard let watchConnectedEvent = self.getEventByType("watchdisconnected") as? MessageEvent else { return }
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
        self.sendMessage([PHONE_MESSAGE: message])
    }
    
}

extension WCMessagePort {
    
    override class func create(context: ScriptContext) -> WCMessagePort {
        return WCMessagePort(context: context)
    }
    
}

// MARK: ********** Basic interactive messaging **********

extension WCMessagePort {
    
    var reachableSession: WCSession? {
        guard let session = self.session where session.reachable else {
            print("Your Apple Watch device is not reachable...")
            if let errorEvent = self.getEventByType("error") as? ErrorEvent {
                errorEvent.registerMessage("Your countered smart watch is not reachable!")
                self.onError(errorEvent)
            }
            return nil
        }
        if let connectEvent = self.getEventByType("connect") as? MessageEvent {
            connectEvent.source = self
            self.dispatchEvent(connectEvent)
        }
        return session
    }
    
    /**
     Send messsage to Apple Watch
     
     - parameter message:      message
     - parameter replyHandler: reply handler
     - parameter errorHandler: error handler
     */
    func sendMessage(message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Void)? = nil, errorHandler: ((NSError) -> Void)? = nil) {
        guard let session = self.reachableSession else { return }
        session.sendMessage(message, replyHandler: replyHandler, errorHandler: {
            error in
            guard let errorEvent = self.getEventByType("error") as? ErrorEvent else { return }
            errorEvent.registerMessage(error.localizedDescription)
            self.dispatchEvent(errorEvent)
        })
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        print("Receiving message without reply handler...")
        if let watchMessage = message[WATCH_MESSAGE] as? String {
            print("Receiving a message from Apple Watch: \(watchMessage)")
            dispatch_async(dispatch_get_main_queue(), {
                // handle response from apple watch
                self.postMessage(watchMessage)
            })
        } else {
            print("Receiving a message: \(message)")
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("Receiving message with reply handler...")
        if let watchMessage = message[WATCH_MESSAGE] as? String {
            print("Receiving a message from Apple Watch: \(watchMessage)")
            dispatch_async(dispatch_get_main_queue(), {
                // handle response from apple watch
                self.postMessage(watchMessage)
            })
        } else {
            print("Receiving a message: \(message)")
        }
    }
    
}

