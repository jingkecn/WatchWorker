//
//  EventTargetDelegate.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 30/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation

public class EventTargetDelegate: NSObject {
    
    var listeners = Dictionary<String, Array<EventListener>>()
    
    func addEventListener(type: String, listener: EventListener) {
        var listeners = self.listeners[type] ?? Array<EventListener>()
        listeners.append(listener)
        self.listeners[type] = listeners
    }
    
    func removeEventListener(type: String?, listener: EventListener?) {
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
    
    func dispatchEvent(event: Event) -> Bool {
        if let listeners = self.listeners[event.type] {
            listeners.forEach({ $0.handleEvent(event) })
            return true
        } else {
            return false
        }
    }
    
}