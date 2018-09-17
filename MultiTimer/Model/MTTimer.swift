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

class MTTimer {
    
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
    
    
}































//class MTTimer {
//    var displayDelegate: TimerDisplayDelegate?
//    var name: String?
//    
//    private var startTime = NSDate().timeIntervalSince1970
//    private var actualSecondsRemaining: Int!
//    private var alarm = MTAlarm()
//    private var mode: TimerMode!
//    private var elapsedTime = 0
//    private var totalTime: Int!
//    private var timer: Timer!
//    var secondsRemaining: Int {
//        get {
//            if mode != .Finished {
//                let now = NSDate().timeIntervalSince1970
//                elapsedTime = Int(now - startTime)
//                return actualSecondsRemaining - elapsedTime
//            } else {
//                return 0
//            }
//        }
//    }
//
//    init(withTotalTimeInSeconds seconds: Int, timerName name: String?) {
//        totalTime = seconds
//        actualSecondsRemaining = seconds
//        if let timerName = name {
//            self.name = timerName
//        }
//        initTimer()
//    }
//    
//    deinit {
//        alarm.cancelPendingAlarm()
//    }
//   
//    private func initTimer() {
//        startTime = NSDate().timeIntervalSince1970
//        mode = .Running
//        alarm.triggerAlarmAfter(timerInterval: Double(actualSecondsRemaining))
//        timer = Timer()
//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
//        timer.fire()
//        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
//    }
//    
//    @objc private func updateTime() {
//        displayDelegate?.timerUpdated(toTime: secondsRemaining)
//        if secondsRemaining <= 0 {
//            timer.invalidate()
//            mode = .Finished
//            
//        }
//    }
//    
//    // Mark - TimerCellDelegate Methods
//    func pause() {
//        actualSecondsRemaining = actualSecondsRemaining - elapsedTime
//        alarm.cancelPendingAlarm()
//        timer.invalidate()
//        mode = .Paused
//    }
//    
//    func resume() {
//        initTimer()
//        mode = .Running
//    }
//    
//    func reset() {
//        timer.invalidate()
//        actualSecondsRemaining = totalTime
//        initTimer()
//    }
//}
