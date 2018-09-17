//
//  TimeConverter.swift
//  MultiTimer
//
//  Created by edan yachdav on 9/10/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import Foundation

struct TimeConverter {
    
    static func convertToSeconds(fromHours hrs: Int, minutes min: Int, seconds sec: Int) -> TimeInterval {
        var timeInSeconds = TimeInterval()
        timeInSeconds += 3600 * Double(hrs)
        timeInSeconds += 60*Double(min)
        timeInSeconds += Double(sec)
        return timeInSeconds
    }
    
    static func convertToString(fromSeconds seconds: Int) -> String {
        let hours = String(seconds/3600)
        let minutes = String((seconds % 3600)/60)
        let seconds = String((seconds % 3600)%60)
        
        return formattedTimeComponent(hours) + ":" + formattedTimeComponent(minutes) + ":" + formattedTimeComponent(seconds)
    }
    
    private static func formattedTimeComponent(_ component: String) -> String {
        var formattedString = component
        if formattedString.count == 1 {
            formattedString = "0" + formattedString
        }
        return formattedString
    }
}
