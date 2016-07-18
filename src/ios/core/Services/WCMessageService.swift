//
//  WCMessageService.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 18/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import WatchConnectivity

class WCMessageService: NSObject, WCSessionDelegate {
    
    static let defaultService = WCMessageService()
    
    var messages = Queue<String>() {
        didSet {
            guard !self.messages.isEmpty else { return }
            while let message = messages.dequeue() {
                self.listeners.forEach({
                    listener in
                    listener(message: message)
                })
            }
        }
    }
    
    var listeners = Array<((message: String) -> Void)>()
    
    var session: WCSession? = {
        guard WCSession.isSupported() else { return nil }
        return WCSession.defaultSession()
    }()
    
    func startService(onSuccess success: ((session: WCSession) -> Void)?, onError error: ((message: String) -> Void)?) {
        self.session?.delegate = self
        self.session?.activateSession()
        if let session = self.session where session.reachable {
            success?(session: session)
        } else {
            error?(message: "Your Apple Watch is not reachable...");
        }
    }
    
    func addMessageListener(listener: (message: String) -> Void) {
        self.listeners.append(listener)
    }
    
}


// MARK: ********** Message receiver **********

extension WCMessageService {
    
    func onMessage(message: String) {
        self.messages.enqueue(message)
    }
    
}

// MARK: ********** Basic interactive messaging **********

extension WCMessageService {
    
    var reachableSession: WCSession? {
        guard let session = self.session where session.reachable else {
            print("Your Apple Watch device is not reachable...")
            return nil
        }
        return session
    }
    
    func sendMessage(message: [String : AnyObject], replyHandler: (([String : AnyObject]) -> Void)? = nil, errorHandler: ((NSError) -> Void)? = nil) {
        guard let session = self.reachableSession else { return }
        session.sendMessage(message, replyHandler: replyHandler, errorHandler: errorHandler)
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        print("Receiving message without reply handler...")
        if let watchMessage = message[WATCH_MESSAGE] as? String {
            print("Receiving a message from Apple Watch: \(watchMessage)")
            dispatch_async(dispatch_get_main_queue(), {
                self.onMessage(watchMessage)
            })
        } else {
            print("Receiving a message: \(message)")
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print("Receiving message with reply handler...")
        if let watchMessage = message[WATCH_MESSAGE] as? String {
            print("Receiving a message from Apple Watch: \(watchMessage)")
            dispatch_async(dispatch_get_main_queue(), {
                self.onMessage(watchMessage)
            })
        } else {
            print("Receiving a message: \(message)")
        }
    }
    
}