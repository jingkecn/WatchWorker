import JavaScriptCore
import ObjectiveC

@objc(WatchWorker) class WatchWorker : CDVPlugin {
    
    typealias MessageListener = (message: String) -> Void
    
    static let sharedInstance = WatchWorker()
    
    let scope: SharedWorkerGlobalScope
    var targetDelegate: EventTargetDelegate?
    
    var worker: SharedWatchWorker?
    var initialized: Bool { return self.worker != nil }
    
    override init() {
        self.scope = SharedWorkerGlobalScope.create(withUrl: "ApplicationScope", withName: "")
        super.init()
    }
    
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
    
    func initializeWatchWorker(withUrl url: String) {
        self.targetDelegate = EventTargetDelegate()
        self.worker = SharedWatchWorker.create(self.scope, scriptURL: url)
        self.worker!.port.addEventListener("message", listener: EventListener.create(withHandler: {
            self.dispatchMessage(($0 as! MessageEvent).data)
        }))
        self.worker!.port.start()
    }
    
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
            self.addListener(type, listener: EventListener.create(withHandler: {
                if let event = $0 as? MessageEvent {
                    result = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: event.data)
                }
                if let event = $0 as? ErrorEvent {
                    result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: event.message)
                }
                // MUST SET true to keep listener alive!!!!!!!!!!
                result.setKeepCallbackAsBool(true)
                self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
            }))
        })
    }
    
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
            self.removeListener(type)
        })
    }
    
}

extension WatchWorker {
    
    func dispatchMessage(message: String) {
        print("Dispatching message: \(message)")
        let event = MessageEvent.create(self.scope, type: "message", initDict: [ "data": message ])
        self.dispatchEvent(event)
    }
    
}

extension WatchWorker {
    
    func addListener(type: String, listener: EventListener) {
        self.targetDelegate?.addEventListener(type, listener: listener)
    }
    
    func removeListener(type: String?) {
        self.targetDelegate?.removeEventListener(type, listener: nil)
    }
    
    func dispatchEvent(event: Event) {
        print("\(self.targetDelegate).dispatching event: \(event)")
        self.targetDelegate?.dispatchEvent(event)
    }
    
}