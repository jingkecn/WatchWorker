/**
 * Error objcet. Specification from: http://www.jsonrpc.org/specification
 * Class {JSONRPCError}
 */

class JSONRPCError {

    constructor(code, message, meaning) {
        this.code = code;
        this.message = message;
        this.meaning = meaning;
    }

    // MARK: ********** Available errors **********

    static get PARSE_ERROR() {
        var code = -32700;
        var message = "Parse error";
        var meaning = "Invalid JSON was received by the server. An error occurred on the server while parsing the JSON text.";
        this.__PARSE_ERROR__ = this.__PARSE_ERROR__ || new JSONRPCError(code, message, meaning);
        return this.__PARSE_ERROR__;
    }

    static get INVALID_REQUEST() {
        var code = -32600;
        var message = "Invalid Request";
        var meaning = "The JSON sent is not a valid Request object.";
        this.__INVALID_REQUEST__ = this.__INVALID_REQUEST__ || new JSONRPCError(code, message, meaning);
        return this.__INVALID_REQUEST__;
    }

    static get METHOD_NOT_FOUND() {
        var code = -32601;
        var message = "Method not found";
        var meaning = "The method does not exist / is not available.";
        this.__METHOD_NOT_FOUND__ = this.__METHOD_NOT_FOUND__ || new JSONRPCError(code, message, meaning);
        return this.__METHOD_NOT_FOUND__;
    }

    static get INVALID_PARAMS() {
        var code = -32602;
        var message = "Invalid params";
        var meaning = "Invalid method parameter(s).";
        this.__INVALID_PARAMS__ = this.__INVALID_PARAMS__ || new JSONRPCError(code, message, meaning);
        return this.__INVALID_PARAMS__;
    }

    static get INTERNAL_ERROR() {
        var code = -32603;
        var message = "Internal error";
        var meaning = "Internal JSON-RPC error.";
        this.__INTERNAL_ERROR__ = this.__INTERNAL_ERROR__ || new JSONRPCError(code, message, meaning);
        return this.__INTERNAL_ERROR__;
    }

    static get SERVER_ERROR() {
        var code = -32000;
        var message = "Server error";
        var meaning = "Reserved for implementation-defined server-errors.";
        this.__SERVER_ERROR__ = this.__SERVER_ERROR__ || new JSONRPCError(code, message, meaning);
        return this.__SERVER_ERROR__;
    }

    static validate(error) {
        // this === JSONRPCError
        return !!error
            || error === this.PARSE_ERROR
            || error === this.INVALID_REQUEST
            || error === this.METHOD_NOT_FOUND
            || error === this.INVALID_PARAMS
            || error === this.INTERNAL_ERROR
            || error === this.SERVER_ERROR;
    }

}