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
    
    var runningTimers = [MTTimer]()
    var completedTimers = [MTTimer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timersTableView.dataSource = self
        timersTableView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTimerFinishedNotificaton(_:)), name: Notification.Name(timerFinishedNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTimerDidUpdateNotification(_:)), name: Notification.Name(timerUpdatedNotification), object: nil)
    }

    @objc private func handleTimerFinishedNotificaton(_ notfication: Notification) {
        if let timer = notfication.object as? MTTimer, let indexOfTimer = runningTimers.index(of: timer) {
            completedTimers.append(runningTimers.remove(at: indexOfTimer))
            timersTableView.reloadData()
        }
    }
    
    @objc private func handleTimerDidUpdateNotification(_ notification: Notification) {
        if let timer = notification.object as? MTTimer, let indexOfTimer = runningTimers.index(of: timer) {
            let indexPath: IndexPath!
            if !completedTimers.isEmpty {
                indexPath = IndexPath(row: indexOfTimer, section: 1)
            } else {
                indexPath = IndexPath(row: indexOfTimer, section: 0)
            }
            if let cell = timersTableView.cellForRow(at: indexPath) as? TimerTableViewCell {
                cell.timeRemainingLabel.text = TimeConverter.convertToString(fromSeconds: timer.timeRemaining)
            }
        }
    }
    
    // Mark: - TimerPicker Delegate method
    func timerCreated(_ timer: MTTimer) {
        runningTimers.append(timer)
        timer.start()
        timersTableView.reloadData()
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
    
    func didTapPauseResumeButton(forCell cell: TimerTableViewCell) {
        if let indexPath = timersTableView.indexPath(for: cell) {
            let timerRowIndex = indexPath.row
            var timer: MTTimer!
                    
            if completedTimers.isEmpty || (!completedTimers.isEmpty && indexPath.section == 1) {
                timer = runningTimers[timerRowIndex]
            } else if indexPath.section == 0 {
                timer = completedTimers[timerRowIndex]
            }
            
            switch timer.timerMode {
            case .Running:
                timer.pause()
                cell.resumePauseActionView.label.text = "Resume"
            case .Paused:
                timer.resume()
                cell.resumePauseActionView.label.text = "Pause"
            case .Finished:
                let timer = completedTimers.remove(at: timerRowIndex)
                runningTimers.append(timer)
                timer.start()
                timersTableView.reloadData()
            }
        }
    }
    
    func didTapCancelButton(forCell cell: TimerTableViewCell) {
        if let indexPath = timersTableView.indexPath(for: cell) {
            let timerRowIndex = indexPath.row
            var timer: MTTimer!
            
            if completedTimers.isEmpty || (!completedTimers.isEmpty && indexPath.section == 1) {
                timer = runningTimers[timerRowIndex]
            } else if indexPath.section == 0 {
                timer = completedTimers[timerRowIndex]
            }
            
            switch timer.timerMode {
            case .Finished:
                completedTimers.remove(at: timerRowIndex)
            default:
                timer.end()
                runningTimers.remove(at: timerRowIndex)
            }
            
            timersTableView.reloadData()
        }
        
    }
}

extension TimersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !completedTimers.isEmpty {
            switch section {
            case 0:
                return completedTimers.count
            case 1:
                return runningTimers.count
            default:
                break
            }
        }
        return runningTimers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return completedTimers.isEmpty ? 1 : 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if completedTimers.count != 0 {
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
        var timer: MTTimer!
        var identifier = String()
        var secondsToDisplay = Int()
        if completedTimers.isEmpty || (!completedTimers.isEmpty && indexPath.section == 1) {
            timer = runningTimers[indexPath.row]
            identifier = "Timer Cell"
            secondsToDisplay = timer.timeRemaining
        } else if indexPath.section == 0 {
            timer = completedTimers[indexPath.row]
            secondsToDisplay = Int(timer.initialTime)
            identifier = "Finished Timer Cell"
        }
        
        let cell = timersTableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! TimerTableViewCell
        
        switch timer.timerMode {
        case .Running:
            cell.resumePauseActionView.label.text = "Pause"
            cell.cancelActionView.label.text = "Cancel"
        case .Paused:
            cell.resumePauseActionView.label.text = "Resume"
            cell.cancelActionView.label.text = "Cancel"
        case .Finished:
            cell.resumePauseActionView.label.text = "Restart"
            cell.cancelActionView.label.text = "Cancel"
            cell.sectionedView.sectionOrientation = .LeftRight
        default:
            break
        }
        
        cell.timeRemainingLabel.text = TimeConverter.convertToString(fromSeconds: secondsToDisplay)
        cell.timerNameLabel.text = timer.name
        cell.timerCellDelegate = self
        
        return cell
        
    }
}
