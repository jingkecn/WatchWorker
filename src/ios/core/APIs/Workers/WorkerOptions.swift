//
//  WorkerOptions.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 04/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

class WorkerOptions: NSObject {
    
    let type: WorkerType
    let credentials: RequestCredentials
    
    private init(type: WorkerType = .Classic, credentials: RequestCredentials = .Omit) {
        self.type = type
        self.credentials = credentials
    }
    
    private convenience init(initializer: JSValue) {
        guard !initializer.isUndefined && !initializer.isNull else {
            self.init()
            return
        }
        let typeValue = initializer.objectForKeyedSubscript("type")
        let typeString = typeValue.isString ? typeValue.toString() : WorkerType.Classic.rawValue
        let type = WorkerType(rawValue: typeString) ?? WorkerType.Classic
        let credentialsValue = initializer.objectForKeyedSubscript("credentials")
        let credentialsString = credentialsValue.isString ? credentialsValue.toString() : RequestCredentials.Omit.rawValue
        let credentials = RequestCredentials(rawValue: credentialsString) ?? RequestCredentials.Omit
        self.init(type: type, credentials: credentials)
    }
    
}

extension WorkerOptions {
    
    class func create(initializer: JSValue) -> WorkerOptions {
        return WorkerOptions(initializer: initializer)
    }
    
}

enum WorkerType: String {
    case Classic = "classic"
    case Module = "module"
}

enum RequestCredentials: String {
    case Omit = "omit"
    case SameOrigin = "same-origin"
    case Include = "include"
}