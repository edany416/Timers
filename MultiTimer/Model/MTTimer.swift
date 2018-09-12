//
//  MTTimer.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/22/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import Foundation
import UserNotifications

enum TimerMode {
    case Running
    case Paused
    case Finished
}

class MTTimer: TimerCellDelegate {
    var displayDelegate: TimerDisplayDelegate?
    var name: String?
    
    private var startTime = NSDate().timeIntervalSince1970
    private var actualSecondsRemaining: Int!
    private var alarm = MTAlarm()
    private var mode: TimerMode!
    private var elapsedTime = 0
    private var totalTime: Int!
    private var timer: Timer!
    var secondsRemaining: Int {
        get {
            if mode != .Finished {
                let now = NSDate().timeIntervalSince1970
                elapsedTime = Int(now - startTime)
                return actualSecondsRemaining - elapsedTime
            } else {
                return 0
            }
        }
    }

    init(withTotalTimeInSeconds seconds: Int, timerName name: String?) {
        totalTime = seconds
        actualSecondsRemaining = seconds
        if let timerName = name {
            self.name = timerName
        }
        initTimer()
    }
    
    private func initTimer() {
        startTime = NSDate().timeIntervalSince1970
        mode = .Running
        alarm.triggerAlarmAfter(timerInterval: Double(actualSecondsRemaining))
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer.fire()
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    @objc private func updateTime() {
        displayDelegate?.timerUpdated(toTime: secondsRemaining)
        if secondsRemaining <= 0 {
            timer.invalidate()
            mode = .Finished
            
        }
    }
    
    // Mark - TimerCellDelegate Methods
    func pauseTapped() {
        actualSecondsRemaining = actualSecondsRemaining - elapsedTime
        alarm.cancelPendingAlarm()
        timer.invalidate()
        mode = .Paused
    }
    
    func resumeTapped() {
        initTimer()
        mode = .Running
    }
    
    func resetTapped() {
        timer.invalidate()
        actualSecondsRemaining = totalTime
        initTimer()
    }
}
