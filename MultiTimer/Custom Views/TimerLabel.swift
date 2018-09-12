//
//  TimerLabel.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/30/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit

class TimerLabel: UILabel, TimerDisplayDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func timerUpdated(toTime secondsLeft: Int) {
        let timeString = TimeConverter.convertToString(fromSeconds: secondsLeft)
        self.text = timeString
    }
    
    private func setup() {
        self.adjustsFontSizeToFitWidth = true
        self.textColor = Constants.darkBlueColor
        self.font = UIFont.monospacedDigitSystemFont(ofSize: 75, weight: UIFont.Weight.thin)
    }
}
