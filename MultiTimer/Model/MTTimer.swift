//
//  MTTimer.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/22/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import Foundation

class MTTimer: Equatable, TimerCellDelegate {
    
    private var endTime: Date!
    private var secondsLeft: Int
    private var initialTime: Int
    private var timer: Timer!
    private var secondPassed = false
    var elapsedTime: MTTime {
        get {
            return MTTime(fromSeconds: secondsLeft)
        }
    }
    var displayDelegate: TimerDisplayDelegate?
    var name: String?
    var isPaused = false
    
    init(withTime time: MTTime, andName name: String?) {
        initialTime = time.timeInSeconds()
        secondsLeft = initialTime
        endTime = Date(timeIntervalSinceNow: Double(initialTime))
        if let timerName = name {
            self.name = timerName
        }
        initTimer()
    }
    
    @objc private func updateTime() {
        if !secondPassed {
            displayDelegate?.timeRemaining(asString: elapsedTime.timeString()!)
            secondPassed = true
        } else {
            if secondsLeft > 0 {
                secondsLeft = secondsLeft - 1
                displayDelegate?.timeRemaining(asString: elapsedTime.timeString()!)
            }
            
        }
        
    }
    
    func pause() {
        if isPaused == false {
            timer.invalidate()
            isPaused = true
            secondPassed = false
        }
    }

    func reset() {
        timer.invalidate()
        secondsLeft = initialTime
        isPaused = false
        secondPassed = false
        initTimer()
    }
    
    func resume() {
        initTimer()
        isPaused = false
    }
    
    private func initTimer() {
        timer = Timer()
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        timer.fire()
        RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
    }
    
    // Mark - Equatable Methods
    static func == (lhs: MTTimer, rhs: MTTimer) -> Bool {
        return lhs == rhs
    }
    
    static func < (lhs: MTTimer, rhs: MTTimer) -> Bool {
        return lhs.endTime < rhs.endTime
    }
}
