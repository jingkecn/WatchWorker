//
//  SwiftyJSONRPC.swift
//  MyGET.JavaScriptCore
//
//  Created by Jing KE on 04/05/16.
//
//

import Foundation

// MARK: ********** Constants **********

// Common attributes
let JSONRPC_VERSION = "2.0"
let ATTR_JSONRPC = "jsonrpc"
// Optional (set to its default value 0 for a notification)
let ATTR_ID = "id"
// Only for request object
let ATTR_METHOD = "method"
let ATTR_PARAMS = "params"
// Only for response object
let ATTR_RESULT = "result"
let ATTR_ERROR = "error"

public protocol JSONRPC {
    // func sendRequest(method method: String, withParams: JSON)
}

public struct JSONRPCMessage {
    var jsonrpc: String = JSONRPC_VERSION
    var id: Int?
    var method: String?
    var params: JSON?
    var result: JSON?
    var error: JSON?
    
    enum JSONRPCMessageType: String {
        case Notification
        case Request
        case ResponseWithResult
        case ResponseWithError
    }
    var type: JSONRPCMessageType = .ResponseWithError
    
    init(fromJSON json: JSON) {
        // self.jsonrpc = json[ATTR_JSONRPC].stringValue
        if let method = json[ATTR_METHOD].string {
            if json[ATTR_ID].int != nil {
                self.type = .Request
            } else {
                self.type = .Notification
            }
            self.method = method
        }
        if let params = json[ATTR_PARAMS].dictionary {
            self.params = JSON(params)
        }
        if let result = json[ATTR_RESULT].dictionary {
            self.type = .ResponseWithResult
            self.result = JSON(result)
        }
        if let error = json[ATTR_ERROR].dictionary {
            self.type = .ResponseWithError
            self.error = JSON(error)
        }
        if let id = json[ATTR_ID].int {
            self.id = id
        }
    }
    
    var jsonValue: JSON {
        var json = JSON([
            ATTR_JSONRPC: self.jsonrpc
        ])
        if let method = self.method {
            json[ATTR_METHOD] = JSON(method)
        }
        if let params = self.params {
            json[ATTR_PARAMS] = params
        }
        if let result = self.result {
            json[ATTR_RESULT] = result
        }
        if let error = self.error {
            json[ATTR_ERROR] = error
        }
        if let id = self.id {
            json[ATTR_ID] = JSON(id)
        }
        return json
    }
    var stringValue: String {
        return JSON.stringify(self.jsonValue)!
    }
}

public protocol JSONRPCMethod {
    // TODO
    var name: String { get set }
    /**
     Execute JSONRPC method with params
     */
    func execute(withParams params: JSON, withCallback callback: ((result: JSON?, error: JSON?) -> Void)?)
}

public class JSONRPCListener {
    var request: JSONRPCMessage
    init(request: JSONRPCMessage) {
        self.request = request
    }
    // TODO
    func onResult(result: JSON, handler: (result: JSON) -> Void) {
//        guard let result = self.result else { return }
        handler(result: result)
    }
    func onError(error: JSON, handler: (error: JSON) -> Void) {
//        guard let error = self.error else { return }
        handler(error: error)
    }
}

public enum JSONRPCError: ErrorType {
    // TODO
    case ParseError
    case InvalidRequest
    case MethodNotFound
    case InvalidParams
    case InternalError
    case Servererror
}