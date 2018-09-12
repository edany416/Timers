//
//  TimerDelegate.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/30/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import Foundation

protocol TimerDisplayDelegate {
    func timerUpdated(toTime secondsLeft: Int)
}
