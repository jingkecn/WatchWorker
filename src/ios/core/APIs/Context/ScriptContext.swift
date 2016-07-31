//
//  ScriptContext.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 27/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

public class ScriptContext: EventTargetDelegate {
    
    var context: JSContext?
    
    var ports = Set<MessagePort>()
    var modules = Set<String>()
    
    override init() {
        super.init()
        self.context = JSContext()
        self.registerGlobalObjects()
        self.registerGlobalFunctions()
        self.preEvaluateScripts()
    }
    
    func destroyContext() {
        NSLog("[ScriptContext] Destroying JSContext: \(self.context)")
        self.ports.forEach({ $0.disentangle() })
        self.context = nil
    }
    
}

extension ScriptContext {
    
    var isValid: Bool {
        return self.context != nil
    }
    
    var executionContext: JSContext? {
        return self.context
    }
    
    var className: String {
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
    
}

extension ScriptContext {
    
    class func create() -> ScriptContext {
        return ScriptContext()
    }
    
}