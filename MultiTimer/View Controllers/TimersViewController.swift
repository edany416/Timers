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

class TimersViewController: UIViewController, TimerPickerDelegate {
    
    @IBOutlet weak var timersTableView: UITableView!
    private var runningTimers = TimerArray()
    private var finishedTimers = TimerArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        timersTableView.dataSource = self
        timersTableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleTimerFinishedNotificaton(_:)), name: Notification.Name(timerFinishedNotification), object: nil)
    }

    @objc private func handleTimerFinishedNotificaton(_ notfication: Notification) {
        if let timer = notfication.object as? MTTimer {
            timer.mode! = .Finished
            timer.displayDelegate = nil
            runningTimers.remove(element: timer)
            finishedTimers.append(newElement: timer)
            timersTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timersTableView.reloadData()
    }

    // Mark: - TimerPicker Delegate method
    func timerCreated(_ timer: MTTimer) {
        runningTimers.append(newElement: timer)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Add Timer Segue" {
            let navVC = segue.destination as! UINavigationController
            if let destVC = navVC.topViewController as? TimerPickerViewController {
                destVC.timerPickerDelegate = self
                destVC.endActionBarButton.title = "Start"
            }
        }
    }
}

extension TimersViewController: TimerCellDelegate {
    // Mark: - Timer Cell Delegate Methods
    func didTapPrimaryActionView(forCell cell: TimerTableViewCell) {
        let indexPath = timersTableView.indexPath(for: cell)
        let timerRowIndex = indexPath?.row
        var timer: MTTimer
        
        if finishedTimers.count != 0 && indexPath?.section == 0 {
            timer = finishedTimers.element(atIndex: timerRowIndex!)
        } else {
            timer = runningTimers.element(atIndex: timerRowIndex!)
        }
        
        switch timer.mode! {
        case .Running:
            timer.pause()
            cell.primaryActionView.label.text = "Resume"
        case .Paused:
            timer.resume()
            cell.primaryActionView.label.text = "Pause"
        case .Finished:
            finishedTimers.remove(atIndex: timerRowIndex!)
            timersTableView.reloadData()
        }
    }
    
    func didTapSecondaryActionView(forCell cell: TimerTableViewCell) {
        let indexPath = timersTableView.indexPath(for: cell)
        let timerRowIndex = indexPath?.row
        var timer: MTTimer
        
        if finishedTimers.count != 0 && indexPath?.section == 0 {
            timer = finishedTimers.element(atIndex: timerRowIndex!)
        } else {
            timer = runningTimers.element(atIndex: timerRowIndex!)
        }
        
        if timer.mode! == .Finished {
            timer.reset()
            runningTimers.append(newElement: timer)
            finishedTimers.remove(atIndex: timerRowIndex!)
        } else {
            timer.displayDelegate = nil
            runningTimers.remove(atIndex: timerRowIndex!)
        }
        timersTableView.reloadData()
    }
}

extension TimersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if finishedTimers.count != 0 {
            switch section {
            case 0:
                return finishedTimers.count
            case 1:
                return runningTimers.count
            default:
                break
            }
        }
        
        return runningTimers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if finishedTimers.count != 0 {
            return 2
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if finishedTimers.count != 0 {
            switch section {
            case 0:
                return "Finished"
            case 1:
                return "Running"
            default:
                break
            }
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        var cell = timersTableView.dequeueReusableCell(withIdentifier: "Timer Cell",
                                                       for: indexPath) as! TimerTableViewCell
        
        var timer: MTTimer
        
        // Finished timer case
        if finishedTimers.count != 0 && indexPath.section == 0 {
            cell = timersTableView.dequeueReusableCell(withIdentifier: "Finished Timer Cell",
                                                       for: indexPath) as! TimerTableViewCell
            timer = finishedTimers.element(atIndex: indexPath.row)
            timer.displayDelegate = nil
            cell.primaryActionView.label.text = "Cancel"
            cell.secondaryActionView.label.text = "Reset"
            cell.timerCellDelegate = self
            cell.timeRemainingLabel.text = TimeConverter.convertToString(fromSeconds: Int(timer.initialTime))
            cell.sectionedView.sectionOrientation = .LeftRight
            return cell
        }
        
        // Running timer case
        timer = runningTimers.element(atIndex: indexPath.row)
        cell.primaryActionView.label.text = "Pause"
        cell.secondaryActionView.label.text = "Cancel"
        cell.timeRemainingLabel.text = TimeConverter.convertToString(fromSeconds: timer.timeRemaining())
        cell.timerNameLabel.text = timer.name
        cell.timerCellDelegate = self
        if timer.displayDelegate != nil {
            timer.displayDelegate = nil
        }
        timer.displayDelegate = cell.timeRemainingLabel
        
        return cell
        
    }
}
