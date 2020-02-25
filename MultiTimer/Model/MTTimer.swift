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
let timerUpdatedNotification = "com.z3dd.timerUpdatedNotification"

class MTTimer: NSObject {
    
    var initialTime: TimeInterval!
    var name: String?
    var timeRemaining: Int {
        if mode == .Finished {
            return 0
        }
        let roundedTimeRemaining = (timeRemainingWithInterruption - elapsedTimeSinceLastStart).rounded(.up)
        return Int(roundedTimeRemaining)
    }
    var timerMode: TimerMode {
        return mode
    }
    
    private var timeRemainingWithInterruption: TimeInterval!
    private var latestStartTime: TimeInterval!
    private var alarm = MTAlarm()
    private var mode: TimerMode!
    private var timer: Timer!
    
    
    let timerID = UUID().uuidString
    
    init(fromTimeInterval timeInterval: TimeInterval, name timerName: String?) {
        super.init()
        name = timerName
        initialTime = timeInterval
        timeRemainingWithInterruption = timeInterval
    }
    
    private var elapsedTimeSinceLastStart: TimeInterval = 0.0
    
    private func updateTimerState() {
        let now = NSDate().timeIntervalSince1970
        elapsedTimeSinceLastStart = now - latestStartTime
        if elapsedTimeSinceLastStart >= timeRemainingWithInterruption {
            endTimer()
        }
    }
    
    private func endTimer() {
        timer.invalidate()
        mode = .Finished
        NotificationCenter.default.post(name: Notification.Name(rawValue: timerFinishedNotification), object: self)
    }
    
    @objc private func timerTicked() {
        updateTimerState()
        NotificationCenter.default.post(name: Notification.Name(rawValue: timerUpdatedNotification), object: self)
    }
    
    func start() {
        mode = .Running
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerTicked), userInfo: nil, repeats: true)
        alarm.triggerAlarmAfter(timerInterval: timeRemainingWithInterruption)
        latestStartTime = NSDate().timeIntervalSince1970
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    func end() {
        alarm.cancelPendingAlarm()
        timer.invalidate()
    }
    
    func pause() {
        alarm.cancelPendingAlarm()
        timer.invalidate()
        mode = .Paused
    }
    
    func resume() {
        timeRemainingWithInterruption = timeRemainingWithInterruption - elapsedTimeSinceLastStart
        elapsedTimeSinceLastStart = 0.0
        start()
    }
    
    func reset() {
        timer.invalidate()
        elapsedTimeSinceLastStart = 0.0
        timeRemainingWithInterruption = initialTime
        start()
    }
    
    static func == (lhs: MTTimer, rhs: MTTimer) -> Bool {
        return lhs.timerID == rhs.timerID
    }
}
