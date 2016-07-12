//
//  SharedWorkerGlobalScope.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 22/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore
import WatchConnectivity

class SharedWorkerGlobalScope: WorkerGlobalScope {
    
    let name: String
    
    private init(name: String) {
        self.name = name
        super.init()
    }
    
}

extension SharedWorkerGlobalScope {
    
    class func create(name: String) -> SharedWorkerGlobalScope {
        return SharedWorkerGlobalScope(name: name)
    }
    
}