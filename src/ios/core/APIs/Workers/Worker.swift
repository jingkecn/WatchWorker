//
//  Worker.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol WorkerJSExport: JSExport {
    
    func terminate()
    func postMessage(message: String)
    
}

class Worker: AbstractWorker {
    
    override init(context: ScriptContext, scriptURL: String) {
        super.init(context: context, scriptURL: scriptURL)
        self.port.addEventListener("message", listener: EventListener.create(withHandler: { self.onMessage(($0 as! MessageEvent).data) }))
    }
    
    override func run() {
        print("==================== [\(self.className)] Start running worker ====================")
        DedicatedWorkerGlobalScope.runWorker(self)
        print("==================== [\(self.className)] End running worker ====================")
    }
    
}

extension Worker: WorkerJSExport {
    
    func terminate() {
        // TODO
        DedicatedWorkerGlobalScope.terminateWorker(self)
    }
    
    func postMessage(message: String) {
        self.port.start()
        self.port.postMessage(message)
    }
    
    func onMessage(message: String) {
        let event = MessageEvent.create(self.context, type: "message", initDict: [ "source": self, "data": message ])
        self.dispatchEvent(event)
        guard let jsEvent = event.thisJSValue else { return }
        guard let this = self.thisJSValue else { return }
        guard let onmessage = this.objectForKeyedSubscript("onmessage") where !onmessage.isUndefined && !onmessage.isNull else { return }
        onmessage.callWithArguments([jsEvent])
    }
    
}

extension Worker {
    
    override class func create(context: ScriptContext, scriptURL: String) -> Worker {
        return Worker(context: context, scriptURL: scriptURL)
    }
    
}