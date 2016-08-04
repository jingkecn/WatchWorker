import JavaScriptCore
import ObjectiveC


/**
 *  Class WatchWorker
 *  This class is aimed to deliver the abilities to communicate with Apple Watch by a HTML5 Worker API
 */
@objc(WatchWorker) class WatchWorker : CDVPlugin {
    
    static let sharedInstance = WatchWorker()
    
    private var targetDelegate: EventTargetDelegate?
    private var scope: SharedWorkerGlobalScope?
    private var worker: SharedWatchWorker?
    private var initialized: Bool { return self.scope != nil && self.worker != nil }
    
    /**
     Worker initializer, processing model:
     1. Delegate this worker itself to an event target delegator to support event system
     2. Initialize an application scope for SharedWatchWorker
     3. Initialize a SharedWatchWorker with the application scope
     4. Add message listener to message port of SharedWatchWorker in outside scope to listen messages from the message port(s) of inside scope
     5. Start the outside message port
     
     - parameter url: script url
     */
    func initializeWatchWorker(withUrl url: String) {
        self.targetDelegate = EventTargetDelegate()
        self.scope = SharedWorkerGlobalScope.create(withUrl: url, withName: "")
        self.worker = SharedWatchWorker.create(self.scope!, scriptURL: url)
        self.worker!.port.addEventListener("message", listener: EventListener.create(withHandler: { self.dispatchMessage(($0 as! MessageEvent).data) }))
        self.worker!.port.start()
    }
    
}

// MARK: - Exposed plugin API

extension WatchWorker {
    
    /**
     Initialization:
     Initialize WatchWorker with an execution script url
     
     - parameter command: cordova plugin command
     */
    func initialize(command: CDVInvokedUrlCommand) {
        self.commandDelegate.runInBackground({
            var result = CDVPluginResult(status: CDVCommandStatus_ERROR)
            guard let initializer = command.arguments[0] as? NSDictionary else {
                result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid initialier")
                self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
                return
            }
            guard let url = initializer["url"] as? String else {
                result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid script URL")
                self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
                return
            }
            self.initializeWatchWorker(withUrl: url)
            result = CDVPluginResult(status: CDVCommandStatus_OK)
            self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
        })
    }
    
    /**
     Message sender: send message to Apple Watch through a asynchronous worker scope
     
     - parameter command: cordova plugin command
     */
    func postMessage(command: CDVInvokedUrlCommand) {
        self.commandDelegate.runInBackground({
            guard self.initialized else { return }
            var result = CDVPluginResult(status: CDVCommandStatus_ERROR)
            guard let initializer = command.arguments[0] as? NSDictionary else {
                result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid initialier")
                self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
                return
            }
            guard let message = initializer["message"] as? String else {
                result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid message")
                self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
                return
            }
            guard let worker = self.worker else {
                result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid worker")
                self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
                return
            }
            worker.port.postMessage(message)
        })
    }
    
    /**
     Event listener handler:
     add event listener such as message listener
     
     - parameter command: cordova command
     */
    func addEventListener(command: CDVInvokedUrlCommand) {
        self.commandDelegate.runInBackground({
            guard self.initialized else { return }
            var result = CDVPluginResult(status: CDVCommandStatus_ERROR)
            guard let initializer = command.arguments[0] as? NSDictionary else {
                result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid initialier")
                self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
                return
            }
            guard let type = initializer["type"] as? String else {
                result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid event type")
                self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
                return
            }
            self.addEventListener(byType: type, withListener: EventListener.create(withHandler: {
                if let event = $0 as? MessageEvent {
                    result = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: event.data)
                }
                if let event = $0 as? ErrorEvent {
                    result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: event.message)
                }
                result.setKeepCallbackAsBool(true)
                self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
            }))
        })
    }
    
    /**
     Event listener handler: 
     remove event listener
     
     - parameter command: cordova command
     */
    func removeEventListener(command: CDVInvokedUrlCommand) {
        self.commandDelegate.runInBackground({
            guard self.initialized else { return }
            var result = CDVPluginResult(status: CDVCommandStatus_ERROR)
            guard let initializer = command.arguments[0] as? NSDictionary else {
                result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid initialier")
                self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
                return
            }
            guard let type = initializer["type"] as? String else {
                result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: "Invalid event type")
                self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
                return
            }
            self.removeEventListener(byType: type)
        })
    }
    
}

// MARK: - Worker dispatchers

extension WatchWorker {
    
    /**
     Message dispatcher: 
     this method is called whenever a message is received by the worker's outside port.
     It'll then dispatch a message event inside this worker scope.
     
     - parameter message: message received
     */
    private func dispatchMessage(message: String) {
        guard let scope = self.scope else { return }
        let event = MessageEvent.create(scope, type: "message", initDict: [ "data": message ])
        self.dispatchEvent(event)
    }
    
}

// MARK: - Event handlers

extension WatchWorker {
    
    private func addEventListener(byType type: String, withListener listener: EventListener) {
        self.targetDelegate?.addEventListener(type, listener: listener)
    }
    
    private func removeEventListener(byType type: String?) {
        self.targetDelegate?.removeEventListener(type, listener: nil)
    }
    
    private func dispatchEvent(event: Event) {
        self.targetDelegate?.dispatchEvent(event)
    }
    
}