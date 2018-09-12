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
        //timerArray.sort(by: <)
    }
    
    func element(atIndex index: Int) -> MTTimer {
        
        return timerArray[index]
    }
    
    mutating func remove(atIndex index: Int) {
        timerArray.remove(at: index)
    }
}
