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
        
        self.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.2039215686, blue: 0.2039215686, alpha: 1)
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true

    }
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
