//
//  HttpRequestImpl.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 24/05/16.
//  Copyright © 2016 Jing KE. All rights reserved.
//

import Foundation
import JavaScriptCore

class HttpRequestImpl: NSObject, HttpRequestImplJSExport {
    
    static let sharedInstance = HttpRequestImpl()
    
    var session: NSURLSession
    var task: NSURLSessionTask?
    
    override init() {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        self.session = NSURLSession(configuration: config)
    }
    
    func fetch(options: JSValue) {
        // TODO
        let url = NSURL(string: options.objectForKeyedSubscript("url").toString())!
        let method = options.objectForKeyedSubscript("method").toString()
        let headers = options.objectForKeyedSubscript("headers").toDictionary()
        let body = options.objectForKeyedSubscript("body")
//        let withCredentials = options.objectForKeyedSubscript("withCredentials").toBool()
        let timeout = options.objectForKeyedSubscript("timeout")
//        let async = options.objectForKeyedSubscript("async").toBool()
        let callback = options.objectForKeyedSubscript("callback")
        print("params: \nurl: \(url)\nmethod: \(method)\nheaders: \(headers)\nbody: \(body)\ntimeout: \(timeout)\ncallback:\(callback)")
        let request = NSMutableURLRequest(URL: url)
        /**
         * If during a connection attempt the request remains idle for longer than the timeout interval, the request is considered to have timed out.
         * The default timeout interval is 60 seconds.
         * As a general rule, you should not use short timeout intervals. 
         * Instead, you should provide an easy way for the user to cancel a long-running operation.
         * In iOS versions prior to iOS 6, the minimum (and default) timeout interval for any request containing a request body was 240 seconds.
         */
        if !timeout.isUndefined {
            request.timeoutInterval = timeout.toDouble() / 1000.00
        }
        request.cachePolicy = .ReloadIgnoringLocalAndRemoteCacheData
        request.HTTPMethod = method
        for (key, header) in headers {
            request.setValue(header as? String, forHTTPHeaderField: key as! String)
        }
        if !body.isUndefined && !body.isNull {
            let bodyString = body.toString().dataUsingEncoding(NSUTF8StringEncoding)
            if let bodyString = bodyString {
                request.HTTPBody = bodyString
                request.setValue("\(bodyString.length)", forHTTPHeaderField: "Content-Length")
            }
        }
        print("Fetching data...")
        print("HTTP Request: \(request) \nHeaders: \(request.allHTTPHeaderFields!)\nBody: \(request.HTTPBody)\nTimeout: \(request.timeoutInterval)")
        self.task = self.session.dataTaskWithRequest(request, completionHandler: {
            data, response, error in
            var result = Dictionary<String, AnyObject>()
            var dataLength = 0;
            if let data = data {
                dataLength = data.length
                result["responseText"] = String(data: data, encoding: NSUTF8StringEncoding)!
                
            }
            let progress: Dictionary<String, AnyObject> = [
                "loaded": dataLength,
                "total": dataLength
            ]
            result["progress"] = progress
            if let error = error {
                print("Error fetching data: \(error)")
                result["error"] = [
                    "code": error.code,
                    "description": error.localizedDescription
                ]
                callback.callWithArguments([result])
                return
            }
            guard let response = response else {
                print("An error eccured: \(HttpRequestImplError.NoResponse)")
                return
            }
            guard let httpResponse = response as? NSHTTPURLResponse else {
                print("An error eccured: \(HttpRequestImplError.BadResponse)")
                return
            }
            print("HTTP Response: \(httpResponse)")
            
            result["status"] = httpResponse.statusCode
            result["statusText"] = NSHTTPURLResponse.localizedStringForStatusCode(httpResponse.statusCode)
            result["responseHeaders"] = httpResponse.allHeaderFields
            result["responseType"] = httpResponse.MIMEType
            callback.callWithArguments([result])
        })
        self.task?.resume()
    }
    
    func abort() {
        // TODO
        self.task?.cancel()
    }
    
}

@objc
protocol HttpRequestImplJSExport: JSExport {
    
    func fetch(params: JSValue) -> Void
    func abort() -> Void
}

// Networking errors
enum HttpRequestImplError: ErrorType {
    case NoResponse
    case BadResponse
    case Other
}