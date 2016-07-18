//
//  SwiftyJSONExtension.swift
//  MyGET
//
//  Created by Jing KE on 28/04/16.
//
//
import Foundation

extension JSON {
    
    /**
     Stringify a JSON object
     
     - parameter json: JSON object
     
     - returns: JSON string (not pretty printed!)
     */
    public static func stringify(json: JSON) -> String? {
        guard let jsonString = json.rawString(NSUTF8StringEncoding, options: NSJSONWritingOptions(rawValue: 0)) else { return nil }
        return jsonString
    }
    
}