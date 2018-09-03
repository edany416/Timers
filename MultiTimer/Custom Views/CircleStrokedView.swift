//
//  CircleStrokedView.swift
//  MultiTimer
//
//  Created by edan yachdav on 9/2/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit

class CircleStrokedView: UIView {
    
    //var textLabel: UILabel!
    private var strokeColor = Constants.lighterDarkBlueColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //addLabelToView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //addLabelToView()
    }
    
    override func draw(_ rect: CGRect) {
        strokeColor.setStroke()
        let minDimesion = (rect.height <= rect.width) ? rect.height : rect.width
        let circlePath = UIBezierPath()
        circlePath.lineWidth = Constants.DefaultLineWidth
        circlePath.addArc(withCenter: centerPoint(), radius: minDimesion/2.5, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        circlePath.stroke()
    }
    
    func setColor(to newColor: UIColor) {
        strokeColor = newColor
        setNeedsLayout()
    }
    
//    private func addLabelToView() {
//        let rect = CGRect(x: 0, y: 0, width: self.bounds.width, height: 20)
//        textLabel = UILabel(frame: rect)
//        textLabel.center = self.convert(self.center, from: textLabel)
//        textLabel.textAlignment = .center
//        textLabel.adjustsFontSizeToFitWidth = true
//        textLabel.text = "Resume"
//        self.addSubview(textLabel)
//
//    }
    
    private func centerPoint() -> CGPoint {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        return center
    }
  

}
