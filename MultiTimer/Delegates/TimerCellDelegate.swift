//
//  TimerCellDelegate.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/29/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import Foundation

protocol TimerCellDelegate {
    func didTapRightActionView(forCell cell: TimerTableViewCell)
    func didTapLeftActionView(forCell cell: TimerTableViewCell)
}
