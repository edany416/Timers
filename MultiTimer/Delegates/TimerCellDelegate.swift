//
//  TimerCellDelegate.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/29/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import Foundation

protocol TimerCellDelegate {
    func didTapPauseResumeButton(forCell cell: TimerTableViewCell)
    func didTapCancelButton(forCell cell: TimerTableViewCell)
}
