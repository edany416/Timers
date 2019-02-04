//
//  TopBottomBorderView.swift
//  MultiTimer
//
//  Created by edan yachdav on 9/17/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit

class TopBottomBorderView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        
        let borderLine = UIBezierPath()
        let lineColor = UIColor.gray
        lineColor.setStroke()
        let lineWidth = CGFloat(0.5)
        borderLine.lineWidth = lineWidth
        
        borderLine.move(to: CGPoint(x: rect.minX, y: rect.maxY - lineWidth))
        borderLine.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - lineWidth))
        borderLine.stroke()
        
        borderLine.move(to: CGPoint(x: rect.minX, y: rect.minY+lineWidth))
        borderLine.addLine(to: CGPoint(x: rect.maxX, y: rect.minY+lineWidth))
        borderLine.stroke()
        
    }
}
