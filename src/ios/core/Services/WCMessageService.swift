//
//  WCMessageService.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 18/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import WatchConnectivity

public class WCMessageService: NSObject, WCSessionDelegate {
    
    typealias MessageListener = (message: String) -> Void
    public typealias StartHandler = () -> Void
    
    public static let sharedInstance = WCMessageService()
    
    var session: WCSession? = {
        guard WCSession.isSupported() else { return nil }
        return WCSession.defaultSession()
    }()
    
    var listeners = Array<MessageListener>()
    
}

extension WCMessageService {
    
    public func startService(onSuccess successHandler: StartHandler? = nil, onError errorHandler: StartHandler? = nil) {
        print("Starting message service. onSuccess = \(successHandler), onError = \(errorHandler)")
        self.session?.delegate = self
        self.session?.activateSession()
        if let session = self.session where session.reachable {
            successHandler?()
        } else {
            errorHandler?()
        }
    }
    
}

extension WCMessageService {
    
    func addMessageListener(listener: MessageListener) {
        self.listeners.append(listener)
    }
    
    func dispatchMessage(message: String) {
        self.listeners.forEach({ $0(message: message) })
    }
    
}

extension WCMessageService {
    
    var isReachable: Bool {
        return self.session?.reachable ?? false
    }
    
    func sendMessage(message: String) {
        guard let session = self.session /*where session.reachable*/ else { return }
        session.sendMessage([PHONE_MESSAGE: message], replyHandler: nil, errorHandler: nil)
    }
    
}

// MARK: ********** Basic interactive messaging **********

extension WCMessageService {
    
    public func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        print("Receiving message without reply handler...")
        if let messageBody = message[WATCH_MESSAGE] as? String {
            print("Receiving a message from iPhone: \(messageBody)")
            dispatch_async(dispatch_get_main_queue(), {
                self.dispatchMessage(messageBody)
            })
        } else {
            print("Receiving an invalid message: \(message)")
        }
    }
    
}