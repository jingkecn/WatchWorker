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
    
    override init(url: String, name: String = "") {
        super.init(url: url, name: name)
        self.addEventListener("watchconnect", listener: EventListener.create(withHandler: self.onWatchConnect))
    }
    
}

extension SharedWatchWorkerGlobalScope {
    
    func dispatchWatchConnection() {
        guard let port = self.port else { return }
        let event = MessageEvent.create(self, type: "watchconnect", initDict: [ "ports": [port], "source": port ])
        self.dispatchEvent(event)
    }
    
    override func dispatchMessage(message: String) {
        super.dispatchMessage(message)
        self.service.sendMessage(message)
    }
    
}

extension SharedWatchWorkerGlobalScope {
    
    func onWatchConnect(event: Event) {
        guard let event = event as? MessageEvent else { return }
        guard let jsEvent = event.thisJSValue else { return }
        guard let onwatchconnect = self.getJSValue(byKey: "onwatchconnect") where !onwatchconnect.isUndefined && !onwatchconnect.isNull else { return }
        onwatchconnect.callWithArguments([jsEvent])
    }
    
}

extension SharedWatchWorkerGlobalScope {
    
    @nonobjc private static var scopes = Set<SharedWatchWorkerGlobalScope>()
    
    override class func create(withUrl url: String, withName name: String = "") -> SharedWatchWorkerGlobalScope {
        let scopes = SharedWatchWorkerGlobalScope.scopes.filter({ return $0.url == url && $0.name == name })
        if let scope = scopes.first { return scope }
        let newScope = SharedWatchWorkerGlobalScope(url: url, name: name)
        SharedWatchWorkerGlobalScope.scopes.insert(newScope)
        return newScope
    }
    
    override class func runWorker(worker: AbstractWorker) {
        guard let worker = worker as? SharedWatchWorker else { return }
        worker.scope = SharedWatchWorkerGlobalScope.create(withUrl: worker.url, withName: worker.name)
        guard let scope = worker.scope as? SharedWatchWorkerGlobalScope else { return }
        scope.evaluateScriptFile(worker.url)
        scope.parentScope = worker.context as? WorkerGlobalScope
        let insidePort = MessagePort.create(scope)
        let outsidePort = worker.port
        insidePort.addEventListener("message", listener: EventListener.create(withHandler: {
            guard let event = $0 as? MessageEvent else { return }
            scope.dispatchMessage(event.data)
        }))
        scope.port = insidePort
        MessageChannel.createChannel(withPort1: insidePort, withPort2: outsidePort)
        scope.parentScope?.childrenScopes.insert(scope)
        scope.dispatchConnection()
        scope.service.addMessageListener({ scope.port!.postMessage($0) })
        guard scope.service.isReachable else { return }
        scope.dispatchWatchConnection()
    }
    
}