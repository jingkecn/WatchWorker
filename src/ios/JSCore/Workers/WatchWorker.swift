//
//  WatchWorker.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

class WatchWorker: Worker {
    
    override func run() {
        WatchWorkerGlobalScope.runWorker(self)
    }
    
}

extension WatchWorker {
    
    override class func create(context: ScriptContext, scriptURL: String) -> WatchWorker {
        return WatchWorker(context: context, scriptURL: scriptURL)
    }
    
}