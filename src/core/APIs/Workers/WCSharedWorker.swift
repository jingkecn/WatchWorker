//
//  WCSharedWorker.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 04/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

class WCSharedWorker: SharedWorker {
    
    override func initMessagePort(withContext context: ScriptContext, withScope scope: SharedWorkerGlobalScope) -> MessagePort {
        let outsidePort = MessagePort.create(context)
        let insidePort = WCMessagePort.create(scope)
        MessageChannel.createChannel(withPort1: insidePort, withPort2: outsidePort)
        return outsidePort
    }
    
}

extension WCSharedWorker {
    
    override class func create(context: ScriptContext, scriptURL: String, name: String = "", options: JSValue? = nil) -> WCSharedWorker {
        if let options = options {
            return WCSharedWorker(context: context, scriptURL: scriptURL, name: name, options: WorkerOptions.create(options))
        } else {
            return WCSharedWorker(context: context, scriptURL: scriptURL)
        }
    }
    
}