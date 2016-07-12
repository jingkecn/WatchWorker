//
//  WorkerMessagingProxy.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 04/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

class WorkerMessagingProxy: NSObject {
    
    let worker: Worker
    
    init(worker: Worker) {
        self.worker = worker
    }
    
}

extension WorkerMessagingProxy {
    
    func postMessageToWorker(message: String, channels: Array<MessagePortChannel>) {
        guard let ports = MessagePort.entanglePorts(self.worker.context, channels: channels) else { return }
        worker.dispatchEvent(MessageEvent.create(self.worker.context, type: "message", messageEventInitDict: ["ports": ports, "data": message]))
    }
    
    func postMessageToWorkerGlobalScope(message: String, channels: Array<MessagePortChannel>) {
        guard let ports = MessagePort.entanglePorts(self.worker.scope, channels: channels) else { return }
        worker.scope.dispatchEvent(MessageEvent.create(self.worker.scope, type: "message", messageEventInitDict: ["ports": ports, "data": message]))
    }
    
}

extension WorkerMessagingProxy {
    
    class func create(worker: Worker) -> WorkerMessagingProxy {
        return WorkerMessagingProxy(worker: worker)
    }
    
}