/**
 * ********** Constants **********
 */
// Common attributes
var JSONRPC_VERSION = "2.0";
var ATTR_JSONRPC = "jsonrpc";
// Optional
var ATTR_ID = "id";
// Only for request object
var ATTR_METHOD = "method";
var ATTR_PARAMS = "params";
// Only for response object
var ATTR_RESULT = "result";
var ATTR_ERROR = "error";
// // Apple Watch
// var PHONE_MESSAGE = "phone_message";
// var WATCH_MESSAGE = "watch_message";

/**
 * ********** Message service **********
 */

class MessageService {
    constructor() {
        this.identifier = 0;
        this.pendingRequests = {};
        this.methods = {};
    }
    // Implementations
    registerRemoteProcedureCallMethod(method) {
        this.methods[method.name] = method;
    }
    // JSON-RPC message receiver
    onNotificationReceived(notification) {
        var method = this.methods[notification.method];
        if (method === (void 0)) {
            return;
        }
        method.execute(notification.params);
    }
    onRequestReceived(request) {
        console.log("Request received", request);
        console.log("Available methods", this.methods);
        var method = this.methods[request.method];
        if (method === (void 0)) {
            console.log("Method not found", request.method);
            return;
        }
        var self = this;
        var callback = function (response) {
            console.log("Response to " + request.id, response);
            self.sendResponse(request.id, response);
        }
        method.execute(request.params, callback);
    }
    onResponseReceived(response) {
        var request = this.pendingRequests[response.id];
        if (request === (void 0)) {
            console.log("Request not found", response.id);
            return;
        }
        if (response.isResponseWithError()) {
            request.resolve(response.result);
            delete this.pendingRequests[request.id];
            return;
        }
        if (response.isResponseWithResult()) {
            request.reject(response.error);
            delete this.pendingRequests[request.id];
            return;
        }
    }
    onMessageReceived(message, self) {
        // console.log("JSON-RPC Service", self);
        console.log("Message received", message);
        try {
            var jsonMessage = JSON.parse(message);
            console.log("JSON message", jsonMessage);
            var jsonRpcMessage = new JSONRPCMessage(jsonMessage);
            console.log("JSON-RPC message", jsonRpcMessage);
            console.log("Notification?",jsonRpcMessage.isNotification());
            console.log("Request?",jsonRpcMessage.isRequest());
            console.log("Respones with error?",jsonRpcMessage.isResponseWithError());
            console.log("Response with result?",jsonRpcMessage.isResponseWithResult());
            console.log("Notification?",jsonRpcMessage.isNotification());
            console.log("Valid JSON-RPC message?",jsonRpcMessage.isValidJSONRPCMessage());
            if (jsonRpcMessage.isNotification()) {
                console.log("isNotification");
                self.onNotificationReceived(jsonRpcMessage);
            } else if (jsonRpcMessage.isRequest()) {
                console.log("isRequest")
                self.onRequestReceived(jsonRpcMessage);
            } else {
                console.log("isOther?");
                self.onResponseReceived(jsonRpcMessage);
            }
        } catch (err) {
            console.error("Message parsing error", err);
        }
    }
    // JSON-RPC message sender
    sendNotification(method, params) {
        var notification = {
            method: method
        }
        if (params !== (void 0)) {
            notification.params = params;
        }
        this.sendMessage(notification);
    }
    sendRequest(method, params) {
        var id = this.identifier++;
        var request = {
            id: id,
            method: method
        }
        if (params !== (void 0)) {
            request.params = params;
        }
        var self = this;
        return new Promise(function (resolve, reject) {
            self.pendingRequests[request.id] = {
                resolve: resolve,
                reject: reject
            };
            self.sendMessage(request);
        });
    }
    sendResponse(id, response) {
        var message = {
            id: id
        };
        if (response.result !== (void 0)) {
            message.result = response.result;
        } else if (response.error !== (void 0)) {
            message.error = response.result;
        }
        this.sendMessage(message);
    }
    sendMessage(message) {
        var jsonRpcMessage = new JSONRPCMessage(message);
        WatchConnectivity.sendMessageToAppleWatch(jsonRpcMessage.stringValue);
    }
}

/**
 * ********** JSON-RPC message **********
 */
class JSONRPCMessage {
    constructor(message) {
        this.jsonrpc = JSONRPC_VERSION
        if (message.id !== (void 0)) {
            this.id = message.id;
        }
        if (message.method !== (void 0)) {
            this.method = message.method;
        }
        if (message.params !== (void 0)) {
            this.params = message.params;
        }
        if (message.result !== (void 0)) {
            this.result = message.result;
        }
        if (message.error !== (void 0)) {
            this.error = message.error
        }
        var json = {
            jsonrpc: this.jsonrpc
        };
        if (this.id) {
            json.id = this.id;
        }
        if (this.method) {
            json.method = this.method;
        }
        if (this.params) {
            json.params = this.params;
        }
        if (this.result) {
            json.result = this.result;
        }
        if (this.error) {
            json.error = this.error;
        }
        this.jsonValue = json;
        this.stringValue = JSON.stringify(this.jsonValue);
    }
    
    // Implementations
    isNotification() {
        return this.id === (void 0) && this.method !== (void 0);
    }
    isRequest() {
        return this.id !== (void 0) && this.method !== (void 0);
    }
    isResponseWithResult() {
        return this.result !== (void 0) && this.error === (void 0);
    }
    isResponseWithError() {
        return this.result === (void 0) && this.error !== (void 0);
    }
    isValidJSONRPCMessage() {
        return this.isNotification()
            || this.isRequest()
            || this.isResponseWithResult()
            || this.isResponseWithError();
    }
}

/**
 * ********** JSON-RPC method **********
 */
class JSONRPCMethod {
    constructor(method) {
        this.name = method.name;
        this.handler = method.handler;
    }
    
    execute(params, callback) {
        console.log("Executing " + this.name + " with params", params);
        console.log("Executing " + this.name + " with callback", callback);
        if (callback === (void 0)) {
            this.handler(params);
        } else {
            this.handler(params, callback);
        }
    }
}

var messageService = new MessageService();