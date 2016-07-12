//
//  SharedWorker.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 04/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol SharedWorkerJSExport: JSExport {
    
    var port: MessagePort? { get }
    
    func terminate()
    
}

class SharedWorker: EventTarget {
    
    var name: String
    var scope: SharedWorkerGlobalScope
    
    var port: MessagePort?
    
    init(context: ScriptContext, scriptURL: String, name: String = "", options: WorkerOptions? = nil) {
        let scope = SharedWorkerGlobalScope.create(name)
        scope.importScripts(scriptURL)
        self.name = name
        self.scope = scope
        super.init(context: context)
        self.port = initMessagePort(withContext: context, withScope: scope)
    }
    
    deinit {
        self.terminate()
    }
    
    func initMessagePort(withContext context: ScriptContext, withScope scope: SharedWorkerGlobalScope) -> MessagePort {
        let outsidePort = MessagePort.create(context)
        let insidePort = MessagePort.create(scope)
        MessageChannel.createChannel(withPort1: insidePort, withPort2: outsidePort)
        return outsidePort
    }
    
}

extension SharedWorker: SharedWorkerJSExport {
    
    func terminate() {
        self.scope.destroyContext()
        self.context.destroyContext()
    }
    
}


extension SharedWorker: AbstractWorker {
    
    func onError(event: ErrorEvent) {
        // TODO
    }
    
}

extension SharedWorker {
    
    @nonobjc static var workers = Array<SharedWorker>()
    
    class func registerWorker(worker: SharedWorker) {
        SharedWorker.workers.append(worker)
    }
    
    class func unregisterWorker(worker: SharedWorker) {
        if let index = SharedWorker.workers.map({ return $0.name }).indexOf(worker.name) {
            SharedWorker.workers.removeAtIndex(index)
        }
    }
    
    class func create(context: ScriptContext, scriptURL: String, name: String = "", options: JSValue? = nil) -> SharedWorker {
        if let options = options {
            return SharedWorker(context: context, scriptURL: scriptURL, name: name, options: WorkerOptions.create(options))
        } else {
            return SharedWorker(context: context, scriptURL: scriptURL)
        }
    }
    
}