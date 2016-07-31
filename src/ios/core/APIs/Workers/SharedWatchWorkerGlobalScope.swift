//
//  SharedWatchWorkerGlobalScope.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 30/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation

class SharedWatchWorkerGlobalScope: SharedWorkerGlobalScope {
    
    let service = WCMessageService.sharedInstance
    
    override init(name: String = "") {
        super.init(name: name)
        self.addEventListener("watchconnect", listener: EventListener.create(withHandler: self.onWatchConnect))
    }
    
}

extension SharedWatchWorkerGlobalScope {
    
    func dispatchWatchConnection(ports: Array<MessagePort>) {
        let event = MessageEvent.create(self, type: "watchconnect", initDict: [ "ports": ports ])
        self.dispatchEvent(event)
    }
    
    override func dispatchMessage(message: String) {
        super.dispatchMessage(message)
        self.service.sendMessage(message)
    }
    
}

extension SharedWatchWorkerGlobalScope {
    
    func onWatchConnect(event: Event) {
        print("==================== [\(self.className)] Start handling watch connect event ====================")
        guard let event = event as? MessageEvent else { return }
        print("1. message event = \(event.debugInfo)")
        guard let jsEvent = event.thisJSValue else { return }
        print("2. event = \(jsEvent), event.instance = \(jsEvent.objectForKeyedSubscript("instance"))")
        guard let onwatchconnect = self.getJSValue(byKey: "onwatchconnect") where !onwatchconnect.isUndefined && !onwatchconnect.isNull else { return }
        print("4. Invoking [onwatchconnect] handler with arguments: \(jsEvent.objectForKeyedSubscript("instance"))")
        onwatchconnect.callWithArguments([jsEvent])
        print("==================== [\(self.className)] End handling watch connect event ====================")
    }
    
}

extension SharedWatchWorkerGlobalScope {
    
    override class func create(name: String = "") -> SharedWatchWorkerGlobalScope {
        let scope = (SharedWatchWorkerGlobalScope.scopes[name] as? SharedWatchWorkerGlobalScope) ?? SharedWatchWorkerGlobalScope(name: name)
        SharedWorkerGlobalScope.scopes[name] = scope
        return scope
    }
    
    override class func runWorker(worker: AbstractWorker) {
        guard let worker = worker as? SharedWatchWorker else { return }
        worker.scope = SharedWatchWorkerGlobalScope.create(worker.name)
        guard let scope = worker.scope as? SharedWatchWorkerGlobalScope else { return }
        scope.worker = worker
        scope.evaluateScriptFile(worker.url)
        let insidePort = MessagePort.create(scope)
        insidePort.addEventListener("message", listener: EventListener.create(withHandler: {
            guard let event = $0 as? MessageEvent else { return }
            scope.dispatchMessage(event.data)
        }))
        scope.insidePort = insidePort
        MessageChannel.createChannel(withPort1: worker.port, withPort2: scope.port!)
        scope.parentScope?.workers.append(scope)
        scope.dispatchConnection([scope.port!])
        scope.service.addMessageListener({ scope.port!.postMessage($0) })
        guard scope.service.isReachable else { return }
        scope.dispatchWatchConnection([scope.port!])
    }
    
}