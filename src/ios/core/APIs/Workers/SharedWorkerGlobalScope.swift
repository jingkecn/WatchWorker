//
//  SharedWorkerGlobalScope.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol SharedWorkerGlobalScopeJSExport: JSExport {
    
    var name: String { get }
    
    func close()
    
}

public class SharedWorkerGlobalScope: WorkerGlobalScope {
    
    let name: String
    
    init(name: String = "") {
        self.name = name
        super.init()
        self.addEventListener("connect", listener: EventListener.create(withHandler: self.onConnect))
    }
    
}

extension SharedWorkerGlobalScope: SharedWorkerGlobalScopeJSExport {
    
    func close() {
        // TODO: close
    }
    
}

extension SharedWorkerGlobalScope {
    
    func dispatchConnection(ports: Array<MessagePort>) {
        let event = MessageEvent.create(self, type: "connect", initDict: [ "ports": ports ])
        self.dispatchEvent(event)
    }
    
}

extension SharedWorkerGlobalScope {
    
    func onConnect(event: Event) {
        print("==================== [\(self.className)] Start handling connection ====================")
        guard let event = event as? MessageEvent else { return }
        guard let jsEvent = event.thisJSValue else { return }
        print("1. jsEvent = \(event)")
        guard let onconnect = self.getJSValue(byKey: "onconnect") where !onconnect.isUndefined && !onconnect.isNull else { return }
        print("2. onconnect = \(onconnect)")
        onconnect.callWithArguments([jsEvent])
        print("==================== [\(self.className)] End handling connection ====================")
    }
}

extension SharedWorkerGlobalScope {
    
    @nonobjc static var scopes = Dictionary<String, SharedWorkerGlobalScope>()
    
    class func create(name: String = "") -> SharedWorkerGlobalScope {
        let scope = SharedWorkerGlobalScope.scopes[name] ?? SharedWorkerGlobalScope(name: name)
        SharedWorkerGlobalScope.scopes[name] = scope
        return scope
    }
    
    override class func runWorker(worker: AbstractWorker) {
        guard let worker = worker as? SharedWorker else { return }
        worker.scope = SharedWorkerGlobalScope.create(worker.name)
        guard let scope = worker.scope as? SharedWorkerGlobalScope else { return }
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
    }
    
}