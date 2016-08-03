//
//  EventListener.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 17/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

//@objc protocol EventListenerJSExport: JSExport {
//    
//    func handleEvent(event: Event)
//    
//}

class EventListener: NSObject {
    
    var callback: JSValue?
    var handler: ((event: Event) -> Void)?
    
    private init(callback: JSValue? = nil, handler: ((event: Event) -> Void)? = nil) {
        self.callback = callback
        if let handler = handler {
            self.handler = handler
        }
    }
    
    func handleEvent(event: Event) {
        if let handler = self.handler {
            dispatch_async(dispatch_get_main_queue(), {
                handler(event: event)
            })
        }
        guard let thisEvent = event.thisJSValue, callback = self.callback else { return }
        dispatch_async(dispatch_get_main_queue(), {
            callback.callWithArguments([thisEvent])
        })
    }
    
}

extension EventListener {
    
    class func create(callback: JSValue) -> EventListener {
        return EventListener(callback: callback)
    }
    
    class func create(withHandler handler: ((event: Event) -> Void)) -> EventListener {
        return EventListener(callback: nil, handler: handler)
    }
    
}