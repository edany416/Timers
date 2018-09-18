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

let timerFinishedNotification = "com.z3dd.timerFinishedNotification"

class MTTimer: Equatable {
    
    var displayDelegate: TimerDisplayDelegate?
    var mode: TimerMode!
    var name: String?
    
    private var latestStartTime: TimeInterval!
    private var initialTime: TimeInterval
    private var timeRemainingWithInterruption: TimeInterval!
    private var timer: Timer!
    
    init(fromTimeInterval timeInterval: TimeInterval, name timerName: String?) {
        name = timerName
        initialTime = timeInterval
        timeRemainingWithInterruption = timeInterval
        initTimer()
    }
    
    private func initTimer() {
        mode = .Running
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerTicked), userInfo: nil, repeats: true)
        latestStartTime = NSDate().timeIntervalSince1970
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    @objc private func timerTicked() {
        updateTimerState()
        displayDelegate?.timerUpdated(toTime: timeRemaining())
    }
    
    private var elapsedTimeSinceLastStart: TimeInterval = 0.0
    
    private func updateTimerState() {
        let now = NSDate().timeIntervalSince1970
        elapsedTimeSinceLastStart = now - latestStartTime
        if elapsedTimeSinceLastStart >= timeRemainingWithInterruption {
            endTimer()
        }
    }
    
    func timeRemaining() -> Int {
        if mode == .Finished {
            return 0
        }
        let roundedTimeRemaining = (timeRemainingWithInterruption - elapsedTimeSinceLastStart).rounded(.up)
        return Int(roundedTimeRemaining)
    }
    
    private func endTimer() {
        timer.invalidate()
        mode = .Finished
        NotificationCenter.default.post(name: Notification.Name(rawValue: timerFinishedNotification), object: self)
    }
    
    func pause() {
        timer.invalidate()
        mode = .Paused
    }
    
    func resume() {
        timeRemainingWithInterruption = timeRemainingWithInterruption - elapsedTimeSinceLastStart
        elapsedTimeSinceLastStart = 0.0
        initTimer()
    }
    
    func reset() {
        timer.invalidate()
        elapsedTimeSinceLastStart = 0.0
        timeRemainingWithInterruption = initialTime
        initTimer()
    }
    
    static func == (lhs: MTTimer, rhs: MTTimer) -> Bool {
        return lhs.timeRemaining() == rhs.timeRemaining()
    }
    
    static func < (lhs: MTTimer, rhs: MTTimer) -> Bool {
        return lhs.timeRemaining() < rhs.timeRemaining()
    }
    
}
