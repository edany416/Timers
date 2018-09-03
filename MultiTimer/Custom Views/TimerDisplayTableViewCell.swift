//
//  TimerDisplayTableViewCell.swift
//  MultiTimer
//
//  Created by edan yachdav on 9/2/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit

class TimerDisplayTableViewCell: UITableViewCell {

    
    @IBOutlet weak var elapsedTimeLabel: TimerLabel!
    @IBOutlet weak var resetView: CircleStrokedView!
    @IBOutlet weak var pauseView: CircleStrokedView!
    @IBOutlet weak var timerNameLabel: UILabel!
    @IBOutlet weak var resetLabel: UILabel!
    @IBOutlet weak var pauseLabel: UILabel!
    
    var timerCellDelegate: TimerCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupActionViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setupActionViews() {
        let pauseViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(pauseViewTapped))
        pauseView.addGestureRecognizer(pauseViewTapGesture)
        let resetViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(resetViewTapped))
        resetView.addGestureRecognizer(resetViewTapGesture)
    }
    
    @objc private func pauseViewTapped() {
        if pauseLabel.text! == "Pause" {
            pauseLabel.text! = "Resume"
            timerCellDelegate?.pause()
        } else {
            pauseLabel.text = "Pause"
            timerCellDelegate?.resume()
        }
    }
    
    @objc private func resetViewTapped() {
        pauseLabel.text = "Pause"
        timerCellDelegate?.reset()
    }

}
