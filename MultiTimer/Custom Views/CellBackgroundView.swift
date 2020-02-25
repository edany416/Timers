//
//  CellBackgroundView.swift
//  MultiTimer
//
//  Created by edan yachdav on 1/6/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

class CellBackgroundView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        
        self.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true

    }
}
