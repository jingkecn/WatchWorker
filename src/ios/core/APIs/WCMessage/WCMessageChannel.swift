//
//  WCMessageChannel.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 29/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

@objc protocol WCMessageChannelJSExport: JSExport {
    
    var port: WCMessagePort { get }
    
}

class WCMessageChannel: JSClassDelegate, WCMessageChannelJSExport {
    
    let port: WCMessagePort
    
    override init(context: ScriptContext) {
        self.port = WCMessagePort.create(context)
        super.init(context: context)
    }
    
}

extension WCMessageChannel {
    
    class func create(context: ScriptContext) -> WCMessageChannel {
        return WCMessageChannel(context: context)
    }
    
}