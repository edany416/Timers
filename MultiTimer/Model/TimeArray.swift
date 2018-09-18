//
//  TimeArray.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/22/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import Foundation

struct TimerArray {
    private var timerArray = [MTTimer]()
    var count: Int {
        get {
            return timerArray.count
        }
    }
    mutating func append(newElement timer: MTTimer) {
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
    
    mutating func remove(atIndex index: Int) {
        timerArray.remove(at: index)
    }
}
