//
//  TimeArray.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/22/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import Foundation

class TimerArray:NSObject, NSCoding {
    private var timerArray = [MTTimer]()
    
    var count: Int {
        get {
            return timerArray.count
        }
    }
    
    override init() {}
    
    init(_ timers: [MTTimer]) {
        self.timerArray += timers
    }
    
    func append(newElement timer: MTTimer) {
        timerArray.append(timer)
        timerArray.sort(by: <)
    }
    
    func element(atIndex index: Int) -> MTTimer {
        
         return timerArray[index]
    }
    
    func index(of timer: MTTimer) -> Int? {
        var index: Int? = 0
        for t in timerArray {
            if t === timer {
                return index
            }
            index! += 1
        }
        index = nil
        return index
    }
    
    func toArray() -> [MTTimer] {
        return timerArray
    }
    
    func remove(atIndex index: Int) {
        timerArray.remove(at: index)
    }
    
    func remove(element timer: MTTimer) {
        timerArray = timerArray.filter{$0 !== timer}
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(timerArray, forKey: PropertyKeys.timers)
    }
    
    required init(coder aDecoder: NSCoder) {
        self.timerArray = aDecoder.decodeObject(forKey: PropertyKeys.timers) as! [MTTimer]
    }
}
