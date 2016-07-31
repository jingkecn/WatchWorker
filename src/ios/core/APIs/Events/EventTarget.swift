//
//  EventTarget.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 17/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol EventTargetJSExport: JSExport {
    
    func addEventListener(type: String, _ callback: JSValue, _ options: JSValue?)
    func removeEventListener(type: String?, _ callback: JSValue?, _ options: JSValue?)
    func dispatchEvent(event: Event) -> Bool
    
}

class EventTarget: JSClassDelegate {
    
    override init(context: ScriptContext) {
        super.init(context: context)
        self.addEventListener("load", listener: EventListener.create(withHandler: self.onLoad))
        self.dispatchLoader()
    }
    
}

extension EventTarget: EventTargetJSExport {
    
    func addEventListener(type: String, _ callback: JSValue, _ options: JSValue? = nil) {
        self.addEventListener(type, listener: EventListener.create(callback))
    }
    
    func removeEventListener(type: String? = nil, _ callback: JSValue? = nil, _ options: JSValue? = nil) {
        if let type = type {
            if let callback = callback {
                var listeners = self.listeners[type] ?? Array<EventListener>()
                let callbacks = listeners.map({ return $0.callback ?? JSValue() })
                if let index = callbacks.indexOf(callback) {
                    let listener = listeners[index]
                    self.removeEventListener(type, listener: listener)
                }
            } else {
                self.removeEventListener(type, listener: nil)
            }
        } else {
            self.removeEventListener(nil, listener: nil)
        }
    }
    
    override func dispatchEvent(event: Event) -> Bool {
        event.attatchEventTarget(self)
        return super.dispatchEvent(event)
    }

}

extension EventTarget {
    
    func dispatchLoader() {
        let event = Event.create(self.context, type: "load", initDict: [:])
        self.dispatchEvent(event)
    }
    
}

extension EventTarget {
    
    func onLoad(event: Event) {
        guard let jsEvent = event.thisJSValue else { return }
        guard let this = self.thisJSValue else { return }
        guard let onload = this.objectForKeyedSubscript("onload") where !onload.isUndefined && !onload.isNull else { return }
        onload.callWithArguments([jsEvent])
    }
    
}

extension EventTarget {
    
    class func create(context: ScriptContext) -> EventTarget {
        return EventTarget(context: context)
    }
    
}