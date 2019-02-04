//
//  SectionedView.swift
//  MultiTimer
//
//  Created by edan yachdav on 2/4/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

enum Orientation {
    case LeftRight
    case TopDown
}

class SectionedView: UIView {
    
    var sectionOrientation: Orientation = .TopDown {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        let borderLine = UIBezierPath()
        let lineColor = UIColor.white
        lineColor.setStroke()
        
        let lineWidth = CGFloat(1.0)
        borderLine.lineWidth = lineWidth
        
        
        switch sectionOrientation {
            case .TopDown:
                //Top border
                borderLine.move(to: CGPoint(x: rect.minX, y: rect.minY+lineWidth))
                borderLine.addLine(to: CGPoint(x: rect.maxX, y: rect.minY+lineWidth))
                borderLine.stroke()
                
                //Center line
                borderLine.move(to: CGPoint(x: rect.midX, y: rect.minY+lineWidth))
                borderLine.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
                borderLine.stroke()
            case .LeftRight:
                //Left border
                borderLine.move(to: CGPoint(x: rect.minX+lineWidth, y: rect.minY))
                borderLine.addLine(to: CGPoint(x: rect.minX+lineWidth, y: rect.maxY))
                borderLine.stroke()
                
                //Center line
                borderLine.move(to: CGPoint(x: rect.minX+lineWidth, y: rect.midY))
                borderLine.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
                borderLine.stroke()
        }
    }

}
