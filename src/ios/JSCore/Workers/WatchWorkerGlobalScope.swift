//
//  WatchWorkerGlobalScope.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore
import WatchConnectivity

class WatchWorkerGlobalScope: DedicatedWorkerGlobalScope, WCSessionDelegate {
    
    var session: WCSession? = {
        guard WCSession.isSupported() else { return nil }
        return WCSession.defaultSession()
    }()
    
    override init() {
        super.init()
        self.session?.delegate = self
        self.session?.activateSession()
        self.addEventListener("watchconnected", listener: EventListener.create(withHandler: self.onWatchConnected))
    }
    
}

extension WatchWorkerGlobalScope {
    
    func dispatchWatchConnection(ports: Array<MessagePort>) {
        let event = MessageEvent.create(self, type: "watchconnected", initDict: [ "ports": ports ])
        self.dispatchEvent(event)
    }
    
}

extension WatchWorkerGlobalScope {
    
    func onWatchConnected(event: Event) {
        print("==================== [\(self.className)] Start handling watch connected event ====================")
        guard let event = event as? MessageEvent else { return }
        print("1. message event = \(event.debugInfo)")
        guard let jsEvent = event.thisJSValue else { return }
        print("2. event = \(jsEvent), event.instance = \(jsEvent.objectForKeyedSubscript("instance"))")
        guard let onwatchconnected = self.getJSValue(byKey: "onwatchconnected") where !onwatchconnected.isUndefined && !onwatchconnected.isNull else { return }
        print("4. Invoking [onwatchconnected] handler with arguments: \(jsEvent.objectForKeyedSubscript("instance"))")
        onwatchconnected.callWithArguments([jsEvent])
        print("==================== [\(self.className)] End handling watch connected event ====================")
    }
    
    override func onMessage(event: Event) {
        super.onMessage(event)
        guard let event = event as? MessageEvent else { return }
        self.sendMessage(event.data)
    }
    
}

// MARK: ********** Basic interactive messaging **********

extension WatchWorkerGlobalScope {
    
    var isReachable: Bool {
        return self.session?.reachable ?? false
    }
    
    func sendMessage(message: String) {
        guard let session = self.session /*where session.reachable*/ else { return }
        session.sendMessage([PHONE_MESSAGE: message], replyHandler: nil, errorHandler: nil)
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        print("Receiving message without reply handler...")
        if let messageBody = message[WATCH_MESSAGE] as? String {
            print("Receiving a message from iPhone: \(messageBody)")
            dispatch_async(dispatch_get_main_queue(), {
                self.postMessage(messageBody)
            })
        } else {
            print("Receiving an invalid message: \(message)")
        }
    }
    
}

extension WatchWorkerGlobalScope {
    
    override class func runWorker(worker: AbstractWorker) {
        super.runWorker(worker)
        guard let worker = worker as? WatchWorker else { return }
        guard let scope = worker.scope as? WatchWorkerGlobalScope else { return }
        guard let port = scope.port else { return }
        guard scope.isReachable else { return }
        scope.dispatchWatchConnection([scope.port!])
    }
    
}