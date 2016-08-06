//
//  ScriptContextGlobal.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

extension ScriptContext {
    
    func registerGlobalObjects() {
        self.registerGlobalObject(self, forKey: "scope")
        self.registerGlobalObject(HttpRequestImpl.sharedInstance, forKey: KEY_FOR_HTTPREQUESTIMPL)
        self.registerGlobalObject(WindowTimers.sharedInstance, forKey: KEY_FOR_WINDOWTIMERS)
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
    
    func importScript(named filename: String) {
        guard let context = self.context else { return }
        guard !self.importedScripts.contains(filename) else { return }
        guard let script = self.fetchScript(named: filename) else { return }
        context.evaluateScript(script)
        print("[ScriptContext.importScript] evaluating script from \(filename)")
        self.importedScripts.insert(filename)
    }
    
    func fetchScript(named filename: String) -> String? {
        guard let rootUrl = self.resolveUrl() else { return nil }
        let enumerator = NSFileManager.defaultManager().enumeratorAtURL(rootUrl, includingPropertiesForKeys: nil, options: .SkipsHiddenFiles, errorHandler: nil)
        var script: String?
        while let url = enumerator?.nextObject() as? NSURL {
            if url.lastPathComponent == filename && url.pathExtension == "js" {
                script = self.fetchScript(fromUrl: url)
            }
        }
        return script
    }
    
    func fetchScript(fromUrl url: NSURL) -> String? {
        var script: String?
        do {
            script = try String(contentsOfURL: url, encoding: NSUTF8StringEncoding)
        } catch (let error) {
            print("Error fetching script from url = \(url), error = \(error)")
        }
        return script
    }
    
    func resolveUrl(withRootDirectory root: String? = nil) -> NSURL? {
        return root == nil ? NSBundle.mainBundle().bundleURL : NSBundle.mainBundle().bundleURL
            .URLByAppendingPathComponent(root!, isDirectory: true)
            .URLByResolvingSymlinksInPath
    }
    
}