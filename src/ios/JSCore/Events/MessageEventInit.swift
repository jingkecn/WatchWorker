//
//  MessageEventInit.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol MessageEventInitJSExport: JSExport {
    
    var data: JSValue { get }
    var origin: String { get }
    var lastEventId: String { get }
    var source: EventTarget? { get }
    var ports: Array<MessagePort> { get }
    
}

class MessageEventInit: EventInit {
    
    var data: String
    var origin: String
    var lastEventId: String
    var source: EventTarget?
    var ports: Array<MessagePort>
    
    init(context: ScriptContext, bubbles: Bool? = nil, cancelable: Bool? = nil, composed: Bool? = nil, data: String? = nil, origin: String? = nil, lastEventId: String? = nil, source: EventTarget? = nil, ports: Array<MessagePort>? = nil) {
        self.data = data ?? ""
        self.origin = origin ?? ""
        self.lastEventId = lastEventId ?? ""
        self.source = source
        self.ports = ports ?? Array<MessagePort>()
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
        let dataValue = initValue.objectForKeyedSubscript("data")
        let data = dataValue.isString ? dataValue.toString() : nil
        let originValue = initValue.objectForKeyedSubscript("origin")
        let origin = originValue.isString ? originValue.toString() : nil
        let lastEventIdValue = initValue.objectForKeyedSubscript("lastEventId")
        let lastEventId = lastEventIdValue.isString ? lastEventIdValue.toString() : nil
        let sourceValue = initValue.objectForKeyedSubscript("source")
        let source = sourceValue.toObjectOfClass(EventTarget) as? EventTarget ?? nil
        let portsValue = initValue.objectForKeyedSubscript("ports")
        var ports = Array<MessagePort>()
        if portsValue.isArray {
            portsValue.toArray().forEach({
                if let port = $0.toObjectOfClass(MessagePort) as? MessagePort {
                    ports.append(port)
                }
            })
        }
        self.init(context: context, bubbles: bubbles, cancelable: cancelable, composed: composed, data: data, origin: origin, lastEventId: lastEventId, source: source, ports: ports)
    }
    
    convenience init(context: ScriptContext, initDict: Dictionary<String, AnyObject>) {
        self.init(
            context: context,
            bubbles: initDict["bubbles"] as? Bool,
            cancelable: initDict["cancelable"] as? Bool,
            composed: initDict["composed"] as? Bool,
            data: initDict["data"] as? String,
            origin: initDict["origin"] as? String,
            lastEventId: initDict["lastEventId"] as? String,
            source: initDict["source"] as? EventTarget,
            ports: initDict["ports"] as? Array<MessagePort>
        )
    }
}

//extension MessageEventInit {
//    
//     var debugInfo: Dictionary<String, AnyObject> {
//        let sourceDebugInfo = self.source.debugDescription
//        let portsDebugInfo = self.ports.map({ return $0.debugDescription })
//        return [
//            "data": self.data,
//            "origin": self.origin,
//            "lastEventId": self.lastEventId,
//            "source": sourceDebugInfo,
//            "ports": portsDebugInfo
//        ]
//    }
//    
//}

extension MessageEventInit {
    
    override class func create(context: ScriptContext, initValue: JSValue) -> MessageEventInit {
        return MessageEventInit(context: context, initValue: initValue)
    }
    
    override class func create(context: ScriptContext, initDict: Dictionary<String, AnyObject>) -> MessageEventInit {
        return MessageEventInit(context: context, initDict: initDict)
    }
    
}