//
//  DedicatedWorkerGlobalScope.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol DedicatedWorkerGlobalScopeJSExport: JSExport {
    
    func postMessage(message: String)
    func close()
    
}

class DedicatedWorkerGlobalScope: WorkerGlobalScope {
    
    override init(url: String) {
        super.init(url: url)
        self.addEventListener("message", listener: EventListener.create(withHandler: self.onMessage))
    }
    
    override func registerGlobalFunctions() {
        super.registerGlobalFunctions()
        self.context?.evaluateScript("function postMessage(message) { scope && scope.postMessage(JSON.stringify(message)); }")
    }
    
}

extension DedicatedWorkerGlobalScope: DedicatedWorkerGlobalScopeJSExport {
    
    func postMessage(message: String) {
        // TODO: post message
        self.port?.start()
        self.port?.postMessage(message)
    }
    
    func close() {
        // TODO: close context
    }
    
    func onMessage(event: Event) {
        print("==================== [\(self.className)] Start handling message ====================")
        guard let event = event as? MessageEvent else { return }
        guard let jsEvent = event.thisJSValue else { return }
        print("1. jsEvent = \(event)")
        guard let onmessage = self.getJSValue(byKey: "onmessage") where !onmessage.isUndefined && !onmessage.isNull else { return }
        print("2. onmessage = \(onmessage)")
        onmessage.callWithArguments([jsEvent])
        print("==================== [\(self.className)] End handling message ====================")
    }
    
}

extension DedicatedWorkerGlobalScope {
    
    override class func create(withUrl url: String) -> DedicatedWorkerGlobalScope {
        return DedicatedWorkerGlobalScope(url: url)
    }
    
    override class func runWorker(worker: AbstractWorker) {
        guard let worker = worker as? Worker else { return }
        worker.scope = DedicatedWorkerGlobalScope.create(withUrl: worker.url)
        guard let scope = worker.scope as? DedicatedWorkerGlobalScope else { return }
        scope.importScript(named: worker.url)
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
    }
    
}


