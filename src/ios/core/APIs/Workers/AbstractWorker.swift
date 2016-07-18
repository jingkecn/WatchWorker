//
//  AbstractWorker.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 04/07/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

protocol AbstractWorker: JSExport {
    
    func onError(event: ErrorEvent)
    
}