//
//  TimerCellDelegate.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/29/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import Foundation

protocol TimerCellDelegate {
    func rightActionButtonTapped(forCell cell: TimerDisplayTableViewCell)
    func leftActionButtonTapped(forCell cell: TimerDisplayTableViewCell)
}
