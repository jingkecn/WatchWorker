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
    
    let url: String
    
    var port: MessagePort?
    
    var isShared: Bool { return self.isKindOfClass(SharedWorkerGlobalScope) || self.isKindOfClass(SharedWatchWorkerGlobalScope) }
    var parentScope: WorkerGlobalScope?
    
    var childrenScopes = Set<WorkerGlobalScope>()
    
    init(url: String) {
        self.url = url
    }
    
//    override func registerGlobalObjects() {
//        super.registerGlobalObjects()
//        self.registerGlobalObject(self, forKey: "self")
//    }
}

extension WorkerGlobalScope: WorkerGlobalScopeJSExport {
    
//    override func preEvaluateScripts() {
//        self.evaluateScriptFile("JSCore");
//    }
    
    override func registerGlobalFunctions() {
        super.registerGlobalFunctions()
        self.context?.evaluateScript("function importScripts(urls) { scope.importScripts(urls); }")
    }
    
    func importScripts(urls: AnyObject) {
        if let url = urls as? String {
            self.importScript(named: url)
        } else if let urls = urls as? Array<String> {
            urls.forEach({ self.importScript(named: $0) })
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
    
    class func create(withUrl url: String) -> WorkerGlobalScope {
        return WorkerGlobalScope(url: url)
    }
    
    class func runWorker(worker: AbstractWorker) {
        worker.scope = WorkerGlobalScope.create(withUrl: worker.url)
        guard let scope = worker.scope else { return }
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
    
    class func killWorker(worker: AbstractWorker) {
        worker.scope = nil
    }
    
    class func terminateWorker(worker: AbstractWorker) {
        worker.scope = nil
    }
    
}