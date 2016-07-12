//
//  EventListener.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 17/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol EventListenerJSExport: JSExport {
    
    func handleEvent(event: Event)
    
}

class EventListener: NSObject, EventListenerJSExport {
    
    let callback: JSValue
    
    private init(callback: JSValue) {
        self.callback = callback
    }
    
    func handleEvent(event: Event) {
        guard let thisEvent = event.thisJSValue else { return }
        dispatch_async(dispatch_get_main_queue(), {
            self.callback.callWithArguments([thisEvent])
        })
    }
    
}

extension EventListener {
    
    class func create(callback: JSValue) -> EventListener {
        return EventListener(callback: callback)
    }
    
}