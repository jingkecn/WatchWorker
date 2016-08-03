class JSONRPCMessage {

    constructor(init) {
        this.jsonrpc = "2.0";
        this.id = init.id ? init.id : null;
        this.method = init.method ? init.method : null;
        this.params = init.params ? init.params : null;
        this.result = init.result ? init.result : null;
        this.error = init.error ? init.error : null;
    }

    get isNotification() { return !this.id && !!this.method; }
    get isRequest() { return !!this.id && !!this.method; }
    get isResponseWithResult() { return !!this.id && !!this.result && !this.error; }
    get isResponseWithError() { return !!this.id && !this.result && !!this.error; }
    get isResponse() { return this.isResponseWithResult || this.isResponseWithError; }
    get isErrorMessage() { return !this.id && !!this.error; }
    get isValid() { return this.isNotification || this.isRequest || this.isResponse || this.isErrorMessage; }

    get stringValue() { return JSON.stringify(this); }

    get type() {
        if (this.isNotification) { return JSONRPCMessage.Type.Notification; }
        if (this.isRequest) { return JSONRPCMessage.Type.Request; }
        if (this.isResponse) { return JSONRPCMessage.Type.Response; }
        if (this.isErrorMessage) { return JSONRPCMessage.Type.ErrorMessage; }
        return JSONRPCMessage.Type.InvalidMessage;
    }

    static get Type() {
        this.__Type__ = this.__Type__ || {
            Notification: "NOTIFICATION",
            Request: "REQUEST",
            Response: "RESPONSE",
            ErrorMessage: "ERROR",
            InvalidMessage: "INVALID",
            validate: function (type) {
                return type === this.Notification.toLowerCase()
                    || type === this.Request.toLowerCase()
                    || type === this.Response.toLowerCase()
                    || type === this.ErrorMessage.toLowerCase()
                    || type === this.InvalidMessage.toLowerCase();
            }
        };
        return this.__Type__;
    }

    static createNotification(method, params) {
        return new JSONRPCMessage({
            method: method,
            params: params
        });
    }

    static createRequest(id, method, params) {
        return new JSONRPCMessage({
            id: id,
            method: method,
            params: params
        });
    }

    static createResponse(id, result, error) {
        return new JSONRPCMessage({
            id: id,
            result: result,
            error: error
        });
    }

    static createErrorMessage(error) {
        return new JSONRPCMessage({
            error: error
        });
    }

}