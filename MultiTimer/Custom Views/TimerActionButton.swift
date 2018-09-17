//
//  TimerActionButton.swift
//  MultiTimer
//
//  Created by edan yachdav on 9/16/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit

class TimerActionButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        initButtonAttributes()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initButtonAttributes()
    }
    
    func setOverallColor(to newColor: UIColor) {
        circleStrokeColor = newColor
        self.setTitleColor(newColor, for: .normal)
        setNeedsDisplay()
    }
    
    func setText(_ text: String?) {
        self.setTitle(text, for: .normal)
    }
    
    private var circleStrokeColor: UIColor!
    private var textColor: UIColor!
    
    private func initButtonAttributes() {
        circleStrokeColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
    }

    override func draw(_ rect: CGRect) {
        circleStrokeColor.setStroke()
        let minDimension = (rect.height <= rect.width) ? rect.height : rect.width
        let circlePath = UIBezierPath()
        circlePath.lineWidth = 1
        circlePath.addArc(withCenter: centerPoint(), radius: minDimension/2.2, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        circlePath.stroke()
    }
    
    private func centerPoint() -> CGPoint {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        return center
    }

}
