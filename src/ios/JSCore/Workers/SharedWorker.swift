//
//  SharedWorker.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol SharedWorkerJSExport: JSExport {
    
    var scriptURL: String { get }
    var name: String { get }
    
    var port: MessagePort { get }
    
}

class SharedWorker: AbstractWorker, SharedWorkerJSExport {
    
    let scriptURL: String
    var name: String
    
    init(context: ScriptContext, scriptURL: String, name: String = "") {
        self.scriptURL = scriptURL
        self.name = name
        super.init(context: context, scriptURL: scriptURL)
        print("\(self.port)")
    }
    
    override func run() {
        print("==================== [\(self.className)] Start running shared worker ====================")
        SharedWorkerGlobalScope.runWorker(self)
        print("==================== [\(self.className)] End running shared worker ====================")
    }
    
}

extension SharedWorker {
    
    class func create(context: ScriptContext, scriptURL: String, name: String = "") -> SharedWorker {
        return SharedWorker(context: context, scriptURL: scriptURL, name: name)
    }
    
}