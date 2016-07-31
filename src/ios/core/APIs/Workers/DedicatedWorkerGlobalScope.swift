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
    
    override init() {
        super.init()
        self.addEventListener("message", listener: EventListener.create(withHandler: self.onMessage))
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
    
    override class func create() -> DedicatedWorkerGlobalScope {
        return DedicatedWorkerGlobalScope()
    }
    
    override class func runWorker(worker: AbstractWorker) {
        guard let worker = worker as? Worker else { return }
        worker.scope = DedicatedWorkerGlobalScope.create()
        guard let scope = worker.scope as? DedicatedWorkerGlobalScope else { return }
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
    }
    
}


