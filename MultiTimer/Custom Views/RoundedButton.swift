//
//  RoundedButton.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/29/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        let minDimesion = (self.bounds.height <= self.bounds.width) ? self.bounds.height : self.bounds.width
        self.layer.cornerRadius = minDimesion/2
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}
