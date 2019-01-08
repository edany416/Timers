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
    private var timersArray = TimerArray()

    override func viewDidLoad() {
        super.viewDidLoad()
        timersTableView.dataSource = self
        timersTableView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleTimerFinishedNotificaton(_:)), name: Notification.Name(timerFinishedNotification), object: nil)
        
        if let timers = DataPersistenceService.loadData() {
            timersArray = TimerArray(timers)
            timersTableView.reloadData()
        }
        
        _ = DataPersistenceService(dataList: timersArray)
        
    }

    @objc private func handleTimerFinishedNotificaton(_ notfication: Notification) {
        if let timer = notfication.object as? MTTimer {
            
            timer.mode! = .Finished
            
            if let index = timersArray.index(of: timer) {
                let indexPath = IndexPath(item: index, section: 0)
                timersTableView.reloadRows(at: [indexPath], with: .automatic)
                
                let cell = timersTableView.cellForRow(at: indexPath) as! TimerTableViewCell
                cell.rightActionView.label.text = "Restart"
                cell.leftActionView.label.text = "Cancel"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timersTableView.reloadData()
    }

    // Mark: - TimerPicker Delegate method
    func timerCreated(_ timer: MTTimer) {
        timersArray.append(newElement: timer)
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
    func didTapRightActionView(forCell cell: TimerTableViewCell) {
        let indexPath = timersTableView.indexPath(for: cell)
        let timerIndex = indexPath?.row
        let timer = timersArray.element(atIndex: timerIndex!)
        
        switch timer.mode! {
        case .Running:
            timer.pause()
            cell.rightActionView.label.text = "Resume"
        case .Paused:
            timer.resume()
            cell.rightActionView.label.text = "Pause"
        case .Finished:
            timer.reset()
            cell.rightActionView.label.text = "Pause"
            cell.leftActionView.label.text = "Restart"
        }
    }
    
    func didTapLeftActionView(forCell cell: TimerTableViewCell) {
        let indexPath = timersTableView.indexPath(for: cell)
        let timerIndex = indexPath?.row
        let timer = timersArray.element(atIndex: timerIndex!)
        
        switch timer.mode! {
        case .Running:
            timer.reset()
        case .Paused:
            timer.reset()
            cell.rightActionView.label.text = "Pause"
        case .Finished:
            let timerAssociatedWithCell = self.timersArray.element(atIndex: timerIndex!)
            timerAssociatedWithCell.displayDelegate = nil
            self.timersArray.remove(atIndex: timerIndex!)
            timersTableView.deleteRows(at: [indexPath!], with: .fade)
        }
    }
}

extension TimersViewController: UITableViewDataSource, UITableViewDelegate {
    
    // Mark: - table view methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = timersTableView.dequeueReusableCell(withIdentifier: "Timer Cell",
                                                       for: indexPath) as! TimerTableViewCell
        let timer = timersArray.element(atIndex: indexPath.row)
        cell.timerNameLabel.text = timer.name
        cell.timeRemainingLabel.text = TimeConverter.convertToString(fromSeconds: timer.timeRemaining())
        cell.timerCellDelegate = self
        if timer.displayDelegate != nil {
            timer.displayDelegate = nil
        }
        timer.displayDelegate = cell.timeRemainingLabel
        
        cell.rightActionView.label.text = "Pause"
        cell.leftActionView.label.text = "Restart"
        
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
}
