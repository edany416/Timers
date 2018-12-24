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

class TimersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TimerCellDelegate {
    
    @IBOutlet weak var timersTableView: UITableView!
    private var timersArray = TimerArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        timersTableView.dataSource = self
        timersTableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleTimerFinishedNotificaton(_:)), name: Notification.Name(timerFinishedNotification), object: nil)
    }

    @objc private func handleTimerFinishedNotificaton(_ notfication: Notification) {
        if let timer = notfication.object as? MTTimer {
            if let index = timersArray.index(of: timer) {
                let indexPath = IndexPath(item: index, section: 0)
                timersTableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timersTableView.reloadData()
    }
    
    // Mark - table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timersTableView.dequeueReusableCell(withIdentifier: "Named Timer Cell",
                                                       for: indexPath) as! TimerTableViewCell
        let timer = timersArray.element(atIndex: indexPath.row)
        cell.timerNameLabel.text = timer.name
        cell.timeRemainingLabel.text = TimeConverter.convertToString(fromSeconds: timer.timeRemaining())
        cell.timerCellDelegate = self
        if timer.displayDelegate != nil {
            timer.displayDelegate = nil
        }
        timer.displayDelegate = cell.timeRemainingLabel
//        configureCellActionButtons(cell, from: timer)
        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let timerAssociatedWithCell = self.timersArray.element(atIndex: indexPath.row)
            timerAssociatedWithCell.displayDelegate = nil
            self.timersArray.remove(atIndex: indexPath.row)
            timersTableView.deleteRows(at: [indexPath], with: .fade)
        }
        tableView.reloadData()
    }
    
    
    
    // Mark - Timer Cell Delegate Methods
    
    internal func actionButtonTapped(forCell cell: TimerTableViewCell) {
        let indexPath = timersTableView.indexPath(for: cell)
        let timer = timersArray.element(atIndex: indexPath!.row)
        switch timer.mode {
        case .Running?:
            timer.pause()
            cell.actionLabel.text = "RESUME"
        case .Paused?:
            timer.resume()
            cell.actionLabel.text = "PAUSE"
        default:
            break
        }
        
    }
    
    private func updateActionButtonText(for cell: TimerTableViewCell, from timer:MTTimer) {
        
    }

    // Mark - Segue Methods
    @IBAction func unwindFromStart(_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? AddTimerViewController {
            timersArray.append(newElement: sourceVC.timer!)
        }
    }
}
