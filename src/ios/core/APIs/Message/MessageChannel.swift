//
//  MessageChannel.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 27/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol MessageChannelJSExport: JSExport {
    
    var port1: MessagePort { get }
    var port2: MessagePort { get }
    
}

class MessageChannel: JSClassDelegate, MessageChannelJSExport {    // EventData + MessagePortQueue
    
    var port1: MessagePort
    var port2: MessagePort
    
    override init(context: ScriptContext) {
        self.port1 = MessagePort.create(context)
        self.port2 = MessagePort.create(context)
        self.port1.entangle(self.port2)
        self.port2.entangle(self.port1)
        super.init(context: context)
    }
    
}

extension MessageChannel {
    
    class func create(context: ScriptContext) -> MessageChannel {
        return MessageChannel(context: context)
    }
    
    class func createChannel(withPort1 port1: MessagePort, withPort2 port2: MessagePort) {
        port1.entangle(port2)
        port2.entangle(port1)
    }
    
}

