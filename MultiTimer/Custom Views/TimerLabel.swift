//
//  TimerLabel.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/30/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit

class TimerLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        self.font = UIFont.monospacedDigitSystemFont(ofSize: 55, weight: UIFont.Weight.thin)
        self.textColor = UIColor.white
        self.adjustsFontSizeToFitWidth = true
    }
}
