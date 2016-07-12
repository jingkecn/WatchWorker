//
//  ScriptContextMessaging.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation


extension ScriptContext {
    
//    func checkConsistency() {
//        self.messagePorts.forEach({
//            messagePort in
//            assert(messagePort.context == self, "Script context consistency error!")
//        })
//    }
    
    func registerMessagePort(messagePort: MessagePort) {
        guard !self.messagePorts.contains(messagePort) else { return }
        self.messagePorts.insert(messagePort)
    }
    
    func unregisterMessagePort(messagePort: MessagePort) {
        guard self.messagePorts.contains(messagePort) else { return }
        self.messagePorts.remove(messagePort)
    }
    
    func processMessagePortMessagesASAP() {
        dispatch_async(dispatch_get_main_queue(), {
            self.dispatchMessageEvent()
        })
    }
    
    func dispatchMessageEvent() {
//        self.checkConsistency()
        let messagePorts = self.messagePorts
        messagePorts.forEach({
            messagePort in
            if self.messagePorts.contains(messagePort) && messagePort.started {
                // dispatch messages
                if let messageEvent = messagePort.getEventByType("message") {
                    messagePort.dispatchEvent(messageEvent)
                }
            }
        })
    }
    
}
