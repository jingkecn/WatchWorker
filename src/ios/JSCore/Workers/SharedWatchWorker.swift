//
//  SharedWatchWorker.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 30/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation

class SharedWatchWorker: SharedWorker{
    
    override func run() {
        print("==================== [\(self.className)] Start running shared watch worker ====================")
        SharedWatchWorkerGlobalScope.runWorker(self)
        print("==================== [\(self.className)] End running shared watch worker ====================")
    }
    
}

extension SharedWatchWorker {
    
    override class func create(context: ScriptContext, scriptURL: String, name: String = "") -> SharedWatchWorker {
        return SharedWatchWorker(context: context, scriptURL: scriptURL, name: name)
    }
    
}