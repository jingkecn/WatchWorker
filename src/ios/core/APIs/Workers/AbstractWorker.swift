//
//  AbstractWorker.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 04/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

class AbstractWorker: EventTarget {
    
    let url: String
    
    let outsidePort: MessagePort
    
    var scope: WorkerGlobalScope?
    
    var isShared: Bool { return self.isKindOfClass(SharedWorker) }
    
    var port: MessagePort { return self.outsidePort }
    
    init(context: ScriptContext, scriptURL: String) {
        self.url = scriptURL
        self.outsidePort = MessagePort.create(context)
        super.init(context: context)
        self.run()
        self.addEventListener("error", listener: EventListener.create(withHandler: self.onError))
    }
    
    func run() {
        WorkerGlobalScope.runWorker(self)
    }
    
    func onError(event: Event) {
        // TODO:
    }
    
}

extension AbstractWorker {
    
    class func create(context: ScriptContext, scriptURL: String) -> AbstractWorker {
        return AbstractWorker(context: context, scriptURL: scriptURL)
    }
    
}