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
    
    func registerEvent(event: Event)
    func getEventByType(type: String) -> Event?
    
    func addEventListener(type: String, _ callback: JSValue, _ options: JSValue?)
    func removeEventListener(type: String?, _ callback: JSValue?, _ options: JSValue?)
    func dispatchEvent(event: Event) -> Bool
    
}

class EventTarget: JSClassDelegate {
    
    var events = Dictionary<String, Event>()
    var listeners = Dictionary<String, Array<EventListener>>()
    
    func addListener(type: String, listener: EventListener, options: AddEventListenerOptions? = nil) {
        var listeners = self.listeners[type] ?? Array<EventListener>()
        listeners.append(listener)
        self.listeners[type] = listeners
    }
    
    func removeListener(type: String? = nil, listener: EventListener? = nil, options: EventListenerOptions? = nil) {
        if let type = type {
            if let listener = listener {
                // MARK: Remove a specific event listener
                var listeners = self.listeners[type] ?? Array<EventListener>()
                if let index = listeners.indexOf(listener) {
                    listeners.removeAtIndex(index)
                    self.listeners[type] = listeners
                }
            } else {
                // MARK: Remove listeners of a typed event
                self.listeners.removeValueForKey(type)
            }
        } else {
            // MARK: Remove all listeners
            self.listeners.removeAll()
        }
    }
}

extension EventTarget: EventTargetJSExport {
    
    func registerEvent(event: Event) {
        event.attatchEventTarget(self)
        self.events[event.type] = event
        print("[\(self.className)][RegisterEvent]: \(self.events)")
    }
    
    func getEventByType(type: String) -> Event? {
        return self.events[type] ?? nil
    }
    
    func addEventListener(type: String, _ callback: JSValue, _ options: JSValue? = nil) {
        if let options = options {
            self.addListener(type, listener: EventListener.create(callback), options: AddEventListenerOptions(options: options))
        } else {
            self.addListener(type, listener: EventListener.create(callback))
        }
    }
    
    func removeEventListener(type: String? = nil, _ callback: JSValue? = nil, _ options: JSValue? = nil) {
        if let type = type {
            if let callback = callback {
                var listeners = self.listeners[type] ?? Array<EventListener>()
                let callbacks = listeners.map({ return $0.callback })
                if let index = callbacks.indexOf(callback) {
                    let listener = listeners[index]
                    self.removeListener(type, listener: listener, options: EventListenerOptions(options: options))
                }
            } else {
                self.removeListener(type)
            }
        } else {
            self.removeListener()
        }
    }
    
    func dispatchEvent(event: Event) -> Bool {
        if let listeners = self.listeners[event.type] {
            listeners.forEach({ $0.handleEvent(event) })
            return true
        } else {
            return false
        }
    }

}

extension EventTarget {
    
    class func create(context: ScriptContext) -> EventTarget {
        return EventTarget(context: context)
    }
    
}