//
//  JSClassDelegate.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 07/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol JSClassDelegateJSExport: JSExport {
    
    var thisJSValue: JSValue? { get }
    
    func registerThisJSValue(value: JSValue)
    
}

class JSClassDelegate: EventTargetDelegate, JSClassDelegateJSExport {
    
    var context: ScriptContext
    
    var className: String {
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
    
    private var this: JSValue?
    
    var thisJSValue: JSValue? {
        if self.this == nil {
            self.this = self.createJSInstance()
        }
        return self.this
    }
    
    init(context: ScriptContext) {
        self.context = context
    }
    
    func registerThisJSValue(value: JSValue) {
        guard value != self.this && !value.isNull && !value.isUndefined else { return }
        self.this = value
    }
    
    func createJSInstance() -> JSValue? {
        self.context.importScript(named: "\(self.className).js")
        guard let jsClass = self.context.getJSValue(byKey: self.className) else { return nil }
        guard let creator = jsClass.objectForKeyedSubscript("create") where !creator.isUndefined && !creator.isNull else { return nil }
        let jsInstance = creator.callWithArguments([self])
        guard !jsInstance.isNull && !jsInstance.isUndefined else { return nil }
        return jsInstance
    }
    
    
}

extension JSClassDelegate {
    
    var debugInfo: Dictionary<String, AnyObject> {
        var debugInfo = Dictionary<String, AnyObject>()
        debugInfo["id"] = self
        debugInfo["context"] = self.context
        debugInfo["this"] = self.this?.objectForKeyedSubscript("instance")
        debugInfo["thisJSValue"] = self.thisJSValue?.objectForKeyedSubscript("instance")
        debugInfo["className"] = self.className
        return debugInfo
    }
    
}