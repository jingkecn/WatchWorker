importScripts("Event");
/**
 * XMLHttpRequest polyfill.
 * This implementation is relying on HttpRequestImpl for actual network communication
 */
class XMLHttpRequest {

    constructor() {
        // Please don't touch that from the outside...
        var self = this;
        this.__impl = {
            method: null,
            url: null,
            async: true,
            username: null,
            password: null,
            headers: {},
            responseHeaders: {},
            events: {
                "readystatechange": [this.onreadystatechange.bind(this)],
                "loadstart": [this.onloadstart.bind(this)],
                "progress": [this.onprogress.bind(this)],
                "abort": [this.onabort.bind(this)],
                "error": [this.onerror.bind(this)],
                "load": [this.onload.bind(this)],
                "timeout": [this.ontimeout.bind(this)],
                "loadend": [this.onloadend.bind(this)]
            },
            emitEvent: function (name, optevent) {
                var callbacks = this.events[name];
                if (callbacks != undefined) {
                    // Emulate Event as first parameter
                    var event = optevent ? optevent : new Event(name, { target: self });

                    // Build arguments array
                    var args = [event];
                    for (var idx = 1; idx < arguments.length; idx++) {
                        args.push(arguments[idx]);
                    }

                    // Call each callback
                    for (var idx = 0; idx < callbacks.length; idx++) {
                        var cb = callbacks[idx];
                        cb.apply(self, args);
                    }
                }
            },

            emitProgressEvent: function (name, init) {
                return this.emitEvent(name, new ProgressEvent(name, init))
            }
        };
        // states
        this.UNSENT = 0;
        this.OPENED = 1;
        this.HEADERS_RECEIVED = 2;
        this.LOADING = 3;
        this.DONE = 4;

        this.readyState = 0;

        this.withCredentials = false;
        this.timeout = 0;
        
        // response
        this.status = 0;
        this.statusText = "";
        
        this.responseType = "";
        this.response = "";
        this.responseText = "";
        this.responseXML = null;
    }

    // Prototype
    // event handler
    onreadystatechange() { }
    onloadstart() { }
    onprogress() { }
    onabort() { }
    onerror() { }
    onload() { }
    ontimeout() { }
    onloadend() { }

    /**
     * @param {string} method
     * @param {string} url
     * @param {boolean=true} async
     * @param {string=} username
     * @param {string=} password
     */
    open(method, url, async, username, password) {
        this.__impl.method = method;
        this.__impl.url = url;

        if (typeof async == "boolean") {
            this.__impl.async = async;
        }

        if (username != undefined) {
            this.__impl.username = username;
        }

        if (password != undefined) {
            this.__impl.password = password;
        }

        this.readyState = this.OPENED;
    }

    /**
     * @param {string} header
     * @param {string} value
     */
    setRequestHeader(header, value) {
        var headers = this.__impl.headers;
        var existing = headers[header];
        if (existing != undefined) {
            if (existing.constructor === String) {
                headers[header] = [existing, value.toString()];
            } else {
                existing.push(value.toString());
            }
        } else {
            headers[header] = value.toString();
        }
    }
    
    /**
     * @param {ArrayBufferView|Blob|Document|DOMString|FormData=} data
     */
    send(data) {
        var self = this;
        var callback = function (result) {
            var progress = {
                loaded: result.progress.loaded,
                total: result.progress.total,
                target: self
            };

            if (result.error) {
                self.__impl.emitProgressEvent("error", progress);
                self.__impl.emitProgressEvent("loadend", progress);
            } else {
                self.readyState = self.DONE;
                self.responseText = result.responseText;
                self.response = result.responseText;
                self.responseType = "text"; //TODO
                self.status = result.status;
                self.statusText = result.statusText;
                self.__impl.responseHeaders = result.responseHeaders;
                self.__impl.emitEvent("readystatechange");
                self.__impl.emitProgressEvent("progress", progress);
                self.__impl.emitProgressEvent("load", progress);
                self.__impl.emitProgressEvent("loadend", progress);
            }
        }

        var params = {
            url: this.__impl.url,
            method: this.__impl.method,
            headers: this.__impl.headers,
            body: data,
            withCredentials: this.withCredentials,
            timeout: this.timeout,
            async: this.__impl.async,
            callback: callback
        };

        this.__impl.req = new HttpRequestImpl();
        // this.__impl.req = HttpRequestImpl.createInstance();
        this.__impl.emitProgressEvent("loadstart");
        this.__impl.req.fetch(params);
    }
    
    abort() {
        if (this.__impl.req) {
            this.__impl.req.abort();
        }
        this.__impl.emitProgressEvent("abort");
        this.__impl.emitProgressEvent("loadend");
    }
    
    addEventListener(listener, callback) {
        var cbs = this.__impl.events[listener];
        if (cbs != undefined) {
            cbs.push(callback);
        }
    }
    
    getResponseHeader(header) {
        var value = this.__impl.responseHeaders[header];
        if (value != undefined) {
            if (value.constructor == String) {
                return value;
            } else {
                return value.join("; ")
            }
        }
    }
    
    getAllResponseHeaders() {
        var result = "";
        for (var header in this.__impl.responseHeaders) {
            result += header + ": " + this.getResponseHeader(header) + "\n";
        }
        return result;
    }
    
    overrideMimeType(mime) {}
}

/**
 * Polyfill for implementation of HttpRequest
 */
class HttpRequestImpl {
    fetch(options) {
        HttpRequestImplSharedInstance.fetch(options);
    }
    abort() {
        HttpRequestImplSharedInstance.abort();
    }
}


/**
 * ProgressEvent
 */

class ProgressEvent extends Event {
    constructor(type, init) {
        super(type, init);
        if (init != undefined) {
            this.lengthComputable = (init.lengthComputable == true);
            this.loaded = (init.loaded ? init.loaded : 0);
            this.total = (init.total ? init.total : 0);
        } else {
            this.lengthComputable = false;
            this.loaded = 0;
            this.total = 0;
        }
    }
}
