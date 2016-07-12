//
//  ScriptContextGlobal.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation


extension ScriptContext {
    
    func registerGlobalObjects() {
        self.registerGlobalObject(self.scope, forKey: "scope")
        self.registerGlobalObject(WindowTimers.sharedInstance, forKey: keyForWindowTimers)
    }
    
    func registerGlobalObject(object: AnyObject, forKey key: String) {
        guard let context = self.context else { return }
        context.setObject(object, forKeyedSubscript: key)
    }
    
    func registerGlobalFunctions() {
        
    }
    
    func registerGlobalFunction(block: @convention(block) () -> Void, forKey key: String) {
        guard let context = self.context else { return }
        context.setObject(unsafeBitCast(block, AnyObject.self), forKeyedSubscript: key)
    }
    
}

extension ScriptContext {
    
    func getJSValue(byKey key: String) -> JSValue? {
//        print("==================== [\(self.className)] Start getting JSValue ====================")
        guard let context = self .context else { return nil }
//        print("[\(self.className)] 1. context = \(self)")
        let value = context.globalObject.objectForKeyedSubscript(key)
//        print("[\(self.className)] 2. value = \(value)")
        guard !value.isUndefined && !value.isNull else { return nil }
//        print("[\(self.className)] 3. valid value = \(value)")
//        print("==================== [\(self.className)] End getting JSValue ====================")
        return value
    }
    
}

extension ScriptContext {
    
    func preEvaluateScripts() {
        // TODO
//        self.evaluateScriptFile("Utilities")
        self.evaluateScriptFile("Polyfills")
    }
    
    func evaluateScriptFile(module: String) {
        guard let context = self.context else { return }
        guard !self.modules.contains(module) else { return }
        do {
            if let path = NSBundle.mainBundle().pathForResource(module, ofType: "js") {
                let script = try String(contentsOfFile: path, encoding: NSUTF8StringEncoding)
                print("Evaluating \(module).js")
                context.evaluateScript(script)
                self.registerModule(module)
            } else {
                print("Unable to read resource files: \(module).js")
            }
        } catch (let error) {
            print("Error while processing script file: \(error)")
        }
    }
    
    func registerModule(module: String) {
        self.modules.insert(module)
    }
    
    func unregisterModule(module: String) -> String? {
        return self.modules.remove(module)
    }
    
}