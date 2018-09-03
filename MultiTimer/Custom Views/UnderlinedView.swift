//
//  UnderlinedView.swift
//  MultiTimer
//
//  Created by edan yachdav on 9/2/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit

class UnderlinedView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {
        let lowerBorderLine = UIBezierPath()
        let lineColor = Constants.lighterDarkBlueColor
        lineColor.setStroke()
        let lineWidth = Constants.DefaultLineWidth
        lowerBorderLine.lineWidth = lineWidth
        lowerBorderLine.move(to: CGPoint(x: rect.minX, y: rect.maxY - lineWidth))
        lowerBorderLine.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - lineWidth))
        lowerBorderLine.stroke()
    }
    

}
