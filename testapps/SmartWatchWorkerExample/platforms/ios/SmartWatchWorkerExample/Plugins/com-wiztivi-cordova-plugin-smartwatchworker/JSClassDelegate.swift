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

class JSClassDelegate: NSObject, JSClassDelegateJSExport {
    
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
//        print("==================== [\(self.className)] Start registering thisJSValue ====================")
//        print("1. value = \(value), value.constructor = \(value.objectForKeyedSubscript("constructor"))")
        guard value != self.this && !value.isNull && !value.isUndefined else { return }
//        print("2. valid value = \(value), value.constructor = \(value.objectForKeyedSubscript("constructor"))")
        self.this = value
//        print("==================== [\(self.className)] End registering thisJSValue ====================")
    }
    
    func createJSInstance() -> JSValue? {
        print("==================== [\(self.className)] Start creating JSInstance ====================")
        print("1. jsClassName = \(self.className)")
        guard let jsClass = self.context.getJSValue(byKey: self.className) else { return nil }
        print("2. jsClass = \(jsClass)")
        let jsInstance = jsClass.invokeMethod("create", withArguments: [self])
        print("3. jsInstance = \(jsInstance.objectForKeyedSubscript("instance"))")
        guard !jsInstance.isNull && !jsInstance.isUndefined else { return nil }
        print("==================== [\(self.className)] End creating JSInstance ====================")
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