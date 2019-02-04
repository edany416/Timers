//
//  TimerActionView.swift
//  MultiTimer
//
//  Created by edan yachdav on 1/6/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit

enum Borders {
    case top
    case bottom
    case left
    case right
}

class TimerActionView: UIView {
    
    private var tapGesture: UITapGestureRecognizer!
    private var circleView: CircleView!
    private var viewTapped = false
    
    var timerActionViewDelegate: TimerActionViewDelegate?
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    @objc func tapHandler(_ sender: UITapGestureRecognizer){
        
        if tapGesture.state == .ended && viewTapped == false {
            
            viewTapped = true
            circleView = CircleView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: self.bounds.width * 0.50,
                                                  height: self.bounds.height * 0.50))
            circleView.center.x = self.bounds.midX
            circleView.center.y = self.bounds.midY
            self.addSubview(circleView)
            
            UIView.animate(withDuration: 0.35, animations: {
                self.isUserInteractionEnabled = false
                self.circleView.transform = CGAffineTransform.init(scaleX: 10, y: 10)
                self.timerActionViewDelegate?.didTapActionView(self)
            }) { (finished) in
                self.circleView.removeFromSuperview()
                self.viewTapped = false
                self.isUserInteractionEnabled = true
            }
        }
        
    }
    
    override func draw(_ rect: CGRect) {
        
    }
    
    private func setup() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapHandler(_:)))
        self.addGestureRecognizer(tapGesture)
        self.clipsToBounds = true
        
        label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height/3))
        self.addSubview(label)
        label.center.x = self.bounds.midX
        label.center.y = self.bounds.midY
        label.textAlignment = .center
        label.textColor = UIColor.white
    }

}

fileprivate class CircleView: UIView {
    
    var circleStrokeColor: UIColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        circleStrokeColor.setFill()
        let minDimension = (rect.height <= rect.width) ? rect.height : rect.width
        let circlePath = UIBezierPath()
        circlePath.lineWidth = 1
        circlePath.addArc(withCenter: centerPoint(), radius: minDimension/2.2, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        circlePath.fill()
    }
    
    private func centerPoint() -> CGPoint {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        return center
    }
    
    private func setup() {
        self.backgroundColor = UIColor.clear
    }
}
