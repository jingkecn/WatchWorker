importScripts("JSONRPCConnector.js");
importScripts("JSONRPCError.js");
importScripts("JSONRPCMessage.js");
importScripts("Sequence.js");

class JSONRPCService extends JSONRPCConnector {

    constructor(port) {
        super(port);
        // Client mode
        this.id = 0;
        this.pendingRequests = {};
        this.addMessageListener("notification", this.onNotification.bind(this));
        this.addMessageListener("request", this.onRequest.bind(this));
        this.addMessageListener("response", this.onResponse.bind(this));
    }

    // MARK: ********** Client mode **********

    sendNotification(method, params) {
        var notification = JSONRPCMessage.createNotification(method, params);
        this.sendMessage(notification);
    }

    sendRequest(method, params) {
        var id = ++this.id;
        var request = JSONRPCMessage.createRequest(id, method, params);
        var self = this;
        return new Promise(function (resolve, reject) {
            self.pendingRequests[request.id] = {
                resolve: resolve,
                reject: reject
            }
            self.sendMessage(request);
        });
    }

    onResponse(response) {
        var request = this.pendingRequests[response.id];
        if (!request) { return; }
        if (response.result) { request.resolve(response.result); return; }
        if (reponse.error) { request.reject(response.error); return; }
    }

    // MARK: ********** Server mode **********

    registerScope(scope) {
        this.scope = scope;
    }

    sendResponse(id, result, error) {
        var response = JSONRPCMessage.createResponse(id, result, error);
        this.sendMessage(response);
    }

    onNotification(notification) {
        console.debug("On notification", notification, this.scope);
        if (!this.scope) { return; }
        var method = this.scope[notification.method];
        if (!method) { 
            this.sendErrorMessage(JSONRPCError.METHOD_NOT_FOUND);
            return; 
        }
        var params = notification.params;
        if (params && Array.isArray(params)) {
            method.apply(this.scope, params);
        } else if (params && typeof params === "object") {
            method.call(this.scope, params);
        } else {
            this.sendErrorMessage(JSONRPCError.INVALID_PARAMS);
            return;
        }
    }

    onRequest(request) {
        var method = this.scope[request.method];
        if (!this.scope) { return; }
        if (!method) { 
            this.sendErrorMessage(JSONRPCError.METHOD_NOT_FOUND);
            return; 
        }
        var self = this, params = request.params;
        if (params && Array.isArray(params)) {
            method.apply(this.scope, params).then(function (result) {
                self.sendResponse(request.id, result, null);
            }).catch(function (error) {
                self.sendResponse(request.id, null, error);
            });
        } else if (params && typeof params === "object") {
            method.call(this.scope, params).then(function (result) {
                self.sendResponse(request.id, result, null);
            }).catch(function (error) {
                self.sendResponse(request.id, null, error);
            });
        } else {
            this.sendErrorMessage(JSONRPCError.INVALID_PARAMS);
            return;
        }
    }

}