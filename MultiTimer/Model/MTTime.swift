//
//  MTTime.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/22/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import Foundation

struct MTTime {
    private(set) var hours: Int?
    private(set) var minutes: Int?
    private(set) var seconds: Int?
    
    init(fromHours hrs: Int?, minutes min: Int?, seconds sec: Int?) {
        self.hours = hrs
        self.minutes = min
        self.seconds = sec
    }
    
    init(fromSeconds seconds: Int) {
        hours = seconds/3600
        minutes = (seconds % 3600)/60
        self.seconds = (seconds % 3600)%60
    }
    
    func timeInSeconds() -> Int {
        var timeInSeconds = Int()
        
        if let hr = hours {
            timeInSeconds += 3600*hr
        }
        if let min = minutes {
            timeInSeconds += 60*min
        }
        if let sec = seconds {
            timeInSeconds += sec
        }
        
        return timeInSeconds
    }
    
    func timeString() -> String? {
        var hourString = "00"
        var minuteString = "00"
        var secondString = "00"
        if hours != nil {
            hourString = String(hours!)
        }
        if minutes != nil {
            minuteString = String(minutes!)
        }
        if seconds != nil {
            secondString = String(seconds!)
        }
        return formattedTime(fromTimeString: hourString) + ":"
                                + formattedTime(fromTimeString: minuteString) + ":"
                                + formattedTime(fromTimeString: secondString)
    }
    
    private func  formattedTime(fromTimeString comp: String) -> String {
        var formattedString = comp
        if formattedString.count == 1 {
            formattedString = "0" + formattedString
        }
        return formattedString
    }
}
