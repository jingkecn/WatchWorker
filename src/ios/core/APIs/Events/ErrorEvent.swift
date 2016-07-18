//
//  ErrorEvent.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 30/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol ErrorEventJSExport: JSExport {
    
    var message: String { get }
    var filename: String { get }
    var lineno: Int { get }
    var colno: Int { get }
    var error: String { get }
    
}

class ErrorEvent: Event {
    
    var message: String
    var filename: String
    var lineno: Int
    var colno: Int
    var error: String
    
    init(context: ScriptContext, type: String, withErrorEventInit initializer: ErrorEventInit) {
        self.message = initializer.message
        self.filename = initializer.filename
        self.lineno = initializer.lineno
        self.colno = initializer.colno
        self.error = initializer.error
        super.init(context: context, type: type, withEventInit: initializer)
    }
    
    func registerMessage(message: String) {
        self.message = message
    }
    
}

extension ErrorEvent {
    
    override class func create(context: ScriptContext, type: String, initValue: JSValue) -> ErrorEvent {
        return ErrorEvent(context: context, type: type, withErrorEventInit: ErrorEventInit.create(context, initValue: initValue))
    }
    
    override class func create(context: ScriptContext, type: String, initDict: Dictionary<String, AnyObject>) -> ErrorEvent {
        return ErrorEvent(context: context, type: type, withErrorEventInit: ErrorEventInit.create(context, initDict: initDict))
    }
    
}