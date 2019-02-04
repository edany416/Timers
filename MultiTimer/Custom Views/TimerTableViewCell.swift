//
//  TimerTableViewCell.swift
//  MultiTimer
//
//  Created by edan yachdav on 12/21/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit

class TimerTableViewCell: UITableViewCell, TimerActionViewDelegate {
    
    @IBOutlet weak var timeRemainingLabel: TimerLabel!
    @IBOutlet weak var timerNameLabel: UILabel!
    @IBOutlet weak var primaryActionView: TimerActionView!
    @IBOutlet weak var secondaryActionView: TimerActionView!
    @IBOutlet weak var sectionedView: SectionedView!
    
    
    var timerCellDelegate: TimerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setup() {
        primaryActionView.timerActionViewDelegate = self
        secondaryActionView.timerActionViewDelegate = self
    }
    
    func didTapActionView(_ actionView: TimerActionView) {
        if actionView === primaryActionView {
            timerCellDelegate?.didTapPrimaryActionView(forCell: self)
        }
        
        if actionView === secondaryActionView {
            timerCellDelegate?.didTapSecondaryActionView(forCell: self)
        }
    }
}
