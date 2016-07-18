import JavaScriptCore
import ObjectiveC

@objc(SmartWatchWorker) class SmartWatchWorker : CDVPlugin {
    
    var worker: WCSharedWorker? {
        didSet {
            guard let worker = self.worker else { return }
            worker.port?.start()
            worker.port?.remote?.start()
        }
    }
    var initialized: Bool { return self.worker != nil }
    
    func initialize(command: CDVInvokedUrlCommand) {
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
        let appScope = WorkerGlobalScope.create()
        self.worker = WCSharedWorker.create(appScope, scriptURL: url)
        result = CDVPluginResult(status: CDVCommandStatus_OK)
        self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
    }
    
    func postMessage(command: CDVInvokedUrlCommand) {
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
        worker.port?.postMessage(message)
    }
    
    func addEventListener(command: CDVInvokedUrlCommand) {
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
        let listener = EventListener.create(withHandler: {
            event in
            if let event = event as? MessageEvent {
                result = CDVPluginResult(status: CDVCommandStatus_OK, messageAsString: event.data)
            }
            if let event = event as? ErrorEvent {
                result = CDVPluginResult(status: CDVCommandStatus_ERROR, messageAsString: event.message)
            }
            self.commandDelegate.sendPluginResult(result, callbackId: command.callbackId)
        })
        self.worker?.port?.addListener(type, listener: listener)
    }
    
    func removeEventListener(command: CDVInvokedUrlCommand) {
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
        self.worker?.port?.removeListener(type)
    }
    
}