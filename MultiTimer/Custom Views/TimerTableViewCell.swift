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
    @IBOutlet weak var resumePauseActionView: TimerActionView!
    @IBOutlet weak var cancelActionView: TimerActionView!
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
        resumePauseActionView.timerActionViewDelegate = self
        cancelActionView.timerActionViewDelegate = self
    }
    
    func didTapActionView(_ actionView: TimerActionView) {
        if actionView === resumePauseActionView {
            timerCellDelegate?.didTapPauseResumeButton(forCell: self)
        }
        
        if actionView === cancelActionView {
            timerCellDelegate?.didTapCancelButton(forCell: self)
        }
    }
}
