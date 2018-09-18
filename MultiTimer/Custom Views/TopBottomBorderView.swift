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
        viewSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewSetup()
    }
    
    private func viewSetup() {
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        
        let lowerBorderLine = UIBezierPath()
        let lineColor = UIColor.white
        lineColor.setStroke()
        let lineWidth = CGFloat(0.5)
        lowerBorderLine.lineWidth = lineWidth
        
        lowerBorderLine.move(to: CGPoint(x: rect.minX, y: rect.maxY - lineWidth))
        lowerBorderLine.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - lineWidth))
        lowerBorderLine.stroke()
        
        lowerBorderLine.move(to: CGPoint(x: rect.minX, y: rect.minY+lineWidth))
        lowerBorderLine.addLine(to: CGPoint(x: rect.maxX, y: rect.minY+lineWidth))
        lowerBorderLine.stroke()
        
    }
}
