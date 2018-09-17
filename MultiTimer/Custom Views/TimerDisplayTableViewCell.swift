//
//  TimerDisplayTableViewCell.swift
//  MultiTimer
//
//  Created by edan yachdav on 9/2/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit
class TimerDisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var timeRemainingLabel: TimerLabel!
    @IBOutlet weak var timerNameLabel: UILabel!
    @IBOutlet weak var leftActionButton: TimerActionButton!
    @IBOutlet weak var rightActionButton: TimerActionButton!
    
    var timerCellDelegate: TimerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func leftButtonTapped(_ sender: TimerActionButton) {
        timerCellDelegate?.leftActionButtonTapped(forCell: self)
    }
    
    @IBAction func rightButtonTapped(_ sender: TimerActionButton) {
        timerCellDelegate?.rightActionButtonTapped(forCell: self)
    }
}
