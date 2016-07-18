//
//  ErrorEventInit.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 30/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

class ErrorEventInit: EventInit {
    
    var message: String
    var filename: String
    var lineno: Int
    var colno: Int
    var error: String
    
    init(context: ScriptContext, bubbles: Bool? = nil, cancelable: Bool? = nil, composed: Bool? = nil, message: String? = nil, filename: String? = nil, lineno: Int? = nil, colno: Int? = nil, error: String? = nil) {
        self.message = message ?? ""
        self.filename = filename ?? ""
        self.lineno = lineno ?? -1
        self.colno = colno ?? -1
        self.error = error ?? "{}"
        super.init(context: context, bubbles: bubbles, cancelable: cancelable, composed: composed)
    }
    
    convenience init(context: ScriptContext, initValue: JSValue) {
        guard !initValue.isUndefined else {
            self.init(context: context, bubbles: false, cancelable: false, composed: false)
            return
        }
        let bubblesValue = initValue.objectForKeyedSubscript("bubbles")
        let bubbles = bubblesValue.isBoolean ? bubblesValue.toBool() : false
        let cancelableValue = initValue.objectForKeyedSubscript("cancelable")
        let cancelable = cancelableValue.isBoolean ? cancelableValue.toBool() : false
        let composedValue = initValue.objectForKeyedSubscript("composed")
        let composed = composedValue.isBoolean ? composedValue.toBool() : false
        let messageValue = initValue.objectForKeyedSubscript("message")
        let message = messageValue.isString ? messageValue.toString() : ""
        let filenameValue = initValue.objectForKeyedSubscript("filename")
        let filename = filenameValue.isString ? filenameValue.toString() : ""
        let linenoValue = initValue.objectForKeyedSubscript("lineno")
        let lineno = linenoValue.isNumber ? Int(linenoValue.toInt32()) : -1
        let colnoValue = initValue.objectForKeyedSubscript("colno")
        let colno = colnoValue.isNumber ? Int(colnoValue.toInt32()) : -1
        let errorValue = initValue.objectForKeyedSubscript("error")
        let error = errorValue.isString ? errorValue.toString() : "{}"
        self.init(context: context, bubbles: bubbles, cancelable: cancelable, composed: composed, message: message, filename: filename, lineno: lineno, colno: colno, error: error)
    }
    
    convenience init(context: ScriptContext, initDict: Dictionary<String, AnyObject>) {
        self.init(
            context: context,
            bubbles: initDict["bubbles"] as? Bool,
            cancelable: initDict["cancelable"] as? Bool,
            composed: initDict["composed"] as? Bool,
            message: initDict["message"] as? String,
            filename: initDict["filename"] as? String,
            lineno: initDict["lineno"] as? Int,
            colno: initDict["colno"] as? Int,
            error: initDict["error"] as? String
        )
    }
    
}

extension ErrorEventInit {
    
    override class func create(context: ScriptContext, initValue: JSValue) -> ErrorEventInit {
        return ErrorEventInit(context: context, initValue: initValue)
    }
    
    override class func create(context: ScriptContext, initDict: Dictionary<String, AnyObject>) -> ErrorEventInit {
        return ErrorEventInit(context: context, initDict: initDict)
    }
    
}