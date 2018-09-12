//
//  TimersViewController.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/29/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications

class TimersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var timersTableView: UITableView!
    private var timersArray = TimerArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        timersTableView.dataSource = self
        timersTableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timersTableView.reloadData()
    }

    // Mark: table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timersTableView.dequeueReusableCell(withIdentifier: "Test Cell",
                                                       for: indexPath) as! TimerDisplayTableViewCell
        let timer = timersArray.element(atIndex: indexPath.row)
        cell.timerCellDelegate = timer
        cell.timerNameLabel.text = timer.name
        cell.elapsedTimeLabel.text = TimeConverter.convertToString(fromSeconds: timer.secondsRemaining)
        cell.resetView.setColor(to: Constants.darkRedColor)
        timer.displayDelegate = cell.elapsedTimeLabel
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let timerAssociatedWithCell = self.timersArray.element(atIndex: indexPath.row)
            timerAssociatedWithCell.displayDelegate = nil
            self.timersArray.remove(atIndex: indexPath.row)
            timersTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func unwindFromStart(_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? AddTimerViewController {
            timersArray.append(newElement: sourceVC.timer!)
        }
    }
}
