//
//  WorkerGlobalScope.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 17/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol WorkerGlobalScopeJSExport: JSExport {
    
    func importScripts(urls: AnyObject)
    
}

public class WorkerGlobalScope: ScriptContext {
    
    var worker: AbstractWorker?
    var insidePort: MessagePort?    
    var port: MessagePort? { return self.insidePort }
    
    var isShared: Bool { return self.worker?.isKindOfClass(SharedWorker) ?? false }
    var parentScope: WorkerGlobalScope? { return self.worker?.context as? WorkerGlobalScope }
    
    var workers = Array<WorkerGlobalScope>()
        
}

extension WorkerGlobalScope: WorkerGlobalScopeJSExport {
    
    override func registerGlobalFunctions() {
        super.registerGlobalFunctions()
        self.evaluateScript("function importScripts(urls) { scope.importScripts(urls); }")
    }
    
    func importScripts(urls: AnyObject) {
        if let module = urls as? String {
            self.evaluateScriptFile(module)
        } else if let modules = urls as? Array<String> {
            for module in modules {
                self.evaluateScriptFile(module)
            }
        }
    }
    
}

extension WorkerGlobalScope {
    
    func dispatchMessage(message: String) {
        let event = MessageEvent.create(self, type: "message", initDict: [ "source": self, "data": message ])
        self.dispatchEvent(event)
    }
    
}

extension WorkerGlobalScope {
    
    func onError(event: Event) {
        // TODO
    }
    
    func onLanguageChange(event: Event) {
        // TODO
    }
    
    func onOffline(event: Event) {
        // TODO
    }
    
    func onOnline(event: Event) {
        // TODO
    }
    
    func onRejectionHandled(event: Event) {
        // TODO
    }
    
    func onUnhandledRejection(event: Event) {
        // TODO
    }

}

extension WorkerGlobalScope {
    
    override class func create() -> WorkerGlobalScope {
        return WorkerGlobalScope()
    }
    
    class func runWorker(worker: AbstractWorker) {
        worker.scope = WorkerGlobalScope.create()
        guard let scope = worker.scope else { return }
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
    
    class func killWorker(worker: AbstractWorker) {
        worker.scope = nil
    }
    
    class func terminateWorker(worker: AbstractWorker) {
        worker.scope = nil
    }
    
}