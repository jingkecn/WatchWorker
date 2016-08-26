//
//  WindowTimers.swift
//  WTVJavaScriptCore
//
//  Created by Jing KE on 17/06/16.
//  Copyright © 2016 WizTiVi. All rights reserved.
//

import Foundation
import JavaScriptCore

public class WindowTimers: NSObject, WindowTimersJSExport {
    
    // MARK: ********** Singleton **********
    
    static let sharedInstance = WindowTimers()
    
    // MARK: ********** Declarations **********
    enum Type: Int {
        case SetTimeout
        case SetInterval
        case SetImmediate
    }
    
    // MARK: ********** Variables **********
    var tasks = Queue<(callback: JSValue, args: JSValue, id: Int, type: Type)>() {
        didSet {
            // print("Task queue: \n\(self.tasks.items)")
            while !self.tasks.isEmpty {
                if let task = self.tasks.dequeue() {
                    // print("Executing :\(task.callback)\n")
                    task.callback.callWithArguments(task.args.toArray())
                }
            }
        }
    }
    var timers = Queue<(timer: NSTimer, id: Int, type: Type)>()
    var identifier = 0;
    
    // MARK: ********** Implementations for JavaScript **********
    
    func setImmediateWithCallback(callback: JSValue, withArgs args: JSValue) -> Int {
        return self.setWindowTimer(callback, args: args, type: .SetImmediate)
    }
    
    func setIntervalWithCallback(callback: JSValue, withInterval interval: JSValue, withArgs args: JSValue) -> Int {
        return self.setWindowTimer(callback, args: args, type: .SetInterval, time: interval.toDouble() / 1000.00)
    }
    
    func setTimeoutWithCallback(callback: JSValue, withDelay delay: JSValue, withArgs args: JSValue) -> Int {
        return self.setWindowTimer(callback, args: args, type: .SetTimeout, time: delay.toDouble() / 1000.00)
    }
    
    func clearImmediateByid(id: Int) {
        self.clearWindowTimer(id, type: .SetImmediate)
    }
    
    func clearIntervalById(id: Int) {
        self.clearWindowTimer(id, type: .SetInterval)
    }
    
    func clearTimeoutById(id: Int) {
        self.clearWindowTimer(id, type: .SetTimeout)
    }
    
    // MARK: ********** Window Timers Implementations **********
    
    private func setWindowTimer(callback: JSValue, args: JSValue, type: Type, time: NSTimeInterval? = nil) -> Int {
        self.identifier += 1
        let id = self.identifier
        dispatch_async(dispatch_get_main_queue(), {
            switch type {
            case .SetImmediate:
                self.tasks.enqueue((callback: callback, args: args, id: id, type: type))
            case .SetInterval:
                let timer = NSTimer.scheduledTimerWithTimeInterval(time!, target: self, selector: #selector(self.targetMethod(_:)), userInfo: ["callback": callback, "args": args, "id": id, "type": type.rawValue], repeats: true)
                self.timers.enqueue(timer: timer, id: id, type: type)
            case .SetTimeout:
                let timer = NSTimer.scheduledTimerWithTimeInterval(time!, target: self, selector: #selector(self.targetMethod(_:)), userInfo: ["callback": callback, "args": args, "id": id, "type": type.rawValue], repeats: false)
                self.timers.enqueue(timer: timer, id: id, type: type)
            }
        })
        return id
    }
    
    private func clearWindowTimer(id: Int, type: Type) {
        if let timerIndex = self.timers.items.map({ item in item.id }).indexOf(id) {
            let item = self.timers.items[timerIndex]
            if item.type == type {
                print("Clearing timer: \n\(item)\n")
                item.timer.invalidate()
                self.timers.items.removeAtIndex(timerIndex)
            }
        }
        if let taskIndex = self.tasks.items.map({ item in return item.id }).indexOf(id) {
            let task = self.tasks.items[taskIndex]
            if task.type == type {
                print("Clearing task: \n\(task)\n")
                self.tasks.items.removeAtIndex(taskIndex)
            }
        }
    }
    
    // MARK: ********** Target method **********
    
    @objc private func targetMethod(timer: NSTimer) -> Void {
        guard let userInfo = timer.userInfo else {
            return
        }
        guard let callback = userInfo["callback"] as? JSValue else {
            return
        }
        guard let args = userInfo["args"] as? JSValue else {
            return
        }
        guard let id = userInfo["id"] as? Int else {
            return
        }
        guard let typeInt = userInfo["type"] as? Int, let type = Type(rawValue: typeInt) else {
            return
        }
        self.tasks.enqueue((callback: callback, args: args, id: id, type: type))
    }
    
    func getSharedInstance() -> WindowTimers {
        return WindowTimers.sharedInstance
    }
    
}

@objc protocol WindowTimersJSExport: JSExport {
    /**
     This method is used to break up long running operations and run a callback function immediately after the browser has completed other operations such as events and display updates.
     
     - parameter callback: the function you wish to call.
     - parameter args:     optional arguments
     
     - returns: the ID of the immediate which can be used later with window.clearImmediate.
     */
    func setImmediateWithCallback(callback: JSValue, withArgs args: JSValue) -> Int
    
    /**
     Repeatedly calls a function or executes a code snippet, with a fixed time delay between each call. Returns an intervalID.
     
     - parameter function: the function you want to be called repeatedly.
     - parameter interval: the number of milliseconds (thousandths of a second) that the setInterval() function should wait before each call to func. As with setTimeout, there is a minimum delay enforced.
     - parameter args:     optional arguments
     
     - returns: a unique interval ID you can pass to clearInterval().
     */
    func setIntervalWithCallback(callback: JSValue, withInterval interval: JSValue, withArgs args: JSValue) -> Int
    
    /**
     Calls a function after a specified delay.
     
     - parameter function: the function you want to execute after delay milliseconds.
     - parameter delay:    the number of milliseconds (thousandths of a second) that the function call should be delayed by. If omitted, it defaults to 0.1 ms.
     - parameter args:     optional arguments
     
     - returns: the numerical ID of the timeout, which can be used later with window.clearTimeout()
     */
    func setTimeoutWithCallback(callback: JSValue, withDelay delay: JSValue, withArgs args: JSValue) -> Int
    
    /**
     This method clears the action specified by window.setImmediate.
     
     - parameter id: a ID returned by window.setImmediate.
     */
    func clearImmediateByid(id: Int)
    
    /**
     Cancels repeated action which was set up using setInterval.
     
     - parameter id: the identifier of the repeated action you want to cancel. This ID is returned from setInterval().
     */
    func clearIntervalById(id: Int)
    
    /**
     Clears the delay set by WindowTimers.setTimeout().
     
     - parameter id: the ID of the timeout you wish to clear, as returned by WindowTimers.setTimeout().
     */
    func clearTimeoutById(id: Int)
    
    func getSharedInstance() -> WindowTimers
    
}