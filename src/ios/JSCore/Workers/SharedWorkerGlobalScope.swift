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
    
    init(url: String, name: String = "") {
        self.name = name
        super.init(url: url)
        self.addEventListener("connect", listener: EventListener.create(withHandler: self.onConnect))
    }
    
}

extension SharedWorkerGlobalScope: SharedWorkerGlobalScopeJSExport {
    
    func close() {
        // TODO: close
    }
    
}

extension SharedWorkerGlobalScope {
    
    func dispatchConnection() {
        guard let port = self.port else { return }
        let event = MessageEvent.create(self, type: "connect", initDict: [ "ports": [port], "source": port ])
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
    
    @nonobjc private static var scopes = Set<SharedWorkerGlobalScope>()
    
    class func create(withUrl url: String, withName name: String) -> SharedWorkerGlobalScope {
        let scopes = SharedWorkerGlobalScope.scopes.filter({ return $0.url == url && $0.name == name })
        if let scope = scopes.first { return scope }
        let newScope = SharedWorkerGlobalScope(url: url, name: name)
        SharedWorkerGlobalScope.scopes.insert(newScope)
        return newScope
    }
    
    override class func runWorker(worker: AbstractWorker) {
        guard let worker = worker as? SharedWorker else { return }
        worker.scope = SharedWorkerGlobalScope.create(withUrl: worker.url, withName: worker.name)
        guard let scope = worker.scope as? SharedWorkerGlobalScope else { return }
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
    }
    
}