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
    
//    var selfValue: WorkerGlobalScope { get }
    var location: WorkerLocation { get }
    var navigator: WorkerNavigator { get }
    func importScripts(urls: AnyObject)
    func close()
    
//    func onError(event: Event)
//    func onLanguageChange(event: Event)
//    func onOffline(event: Event)
//    func onOnline(event: Event)
//    // FIXME: should pass a PromiseRejectionEvent object
//    func onRejectionHandled(event: Event)
//    func onUnhandledRejection(event: Event)
}

class WorkerGlobalScope: ScriptContext {
    
    var closing = false
    
    deinit {
        self.close()
    }
    
}

extension WorkerGlobalScope: WorkerGlobalScopeJSExport {
    
//    var selfValue: WorkerGlobalScope { return self }
    var location: WorkerLocation { return WorkerLocation() }
    var navigator: WorkerNavigator { return WorkerNavigator() }
    
    func importScripts(urls: AnyObject) {
        if let module = urls as? String {
            self.evaluateScriptFile(module)
        } else if let modules = urls as? Array<String> {
            for module in modules {
                self.evaluateScriptFile(module)
            }
        }
    }
    
    func close() {
        print("[WorkerGlobalScope] Closing JSContext")
        self.closing = true
        self.destroyContext()
    }
    
}

extension WorkerGlobalScope {
    
//    func onError(event: Event) {
//        // TODO
//        self.dispatchEvent(event)
//    }
//    
//    func onLanguageChange(event: Event) {
//        // TODO
//        self.dispatchEvent(event)
//    }
//    
//    func onOffline(event: Event) {
//        // TODO
//        self.dispatchEvent(event)
//    }
//    
//    func onOnline(event: Event) {
//        // TODO
//        self.dispatchEvent(event)
//    }
//    
//    func onRejectionHandled(event: Event) {
//        // TODO
//        self.dispatchEvent(event)
//    }
//    
//    func onUnhandledRejection(event: Event) {
//        // TODO
//        self.dispatchEvent(event)
//    }

}

extension WorkerGlobalScope {
    
    override func registerGlobalFunctions() {
        super.registerGlobalFunctions()
        guard let context = self.context else { return }
        context.evaluateScript("function importScripts(urls) { scope && scope.importScripts(urls); }")
    }
    
}

extension WorkerGlobalScope {
    
    class func create() -> WorkerGlobalScope {
        return WorkerGlobalScope()
    }
    
}