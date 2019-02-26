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
    
    @IBOutlet weak var favoritesViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var timersTableView: UITableView!
    @IBOutlet weak var favoritesCollectionView: UICollectionView!
    
    private var favoritesExpanded = false
    private var runningTimers = TimerArray()
    private var finishedTimers = TimerArray()
    private var favoriteTimers = TimerArray()
    
    private var riceTimer = MTTimer(fromTimeInterval: 1080.0, name: "Rice")
    private var pastaTimer = MTTimer(fromTimeInterval: 300.0, name: "Pasta")
    private var eggsTimer = MTTimer(fromTimeInterval: 720.0, name: "Eggs")
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timersTableView.dataSource = self
        timersTableView.delegate = self
        
        favoritesCollectionView.dataSource = self
        favoritesCollectionView.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTimerFinishedNotificaton(_:)), name: Notification.Name(timerFinishedNotification), object: nil)
        favoritesViewHeightConstraint.constant = 0.0
        
        favoriteTimers.append(newElement: riceTimer)
        favoriteTimers.append(newElement: pastaTimer)
        favoriteTimers.append(newElement: eggsTimer)
        
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
    }

    // Mark: - TimerPicker Delegate method
    func timerCreated(_ timer: MTTimer) {
        runningTimers.append(newElement: timer)
        timersTableView.reloadData()
    }
    
    @IBAction func favoritesTapped(_ sender: UIBarButtonItem) {
        if !favoritesExpanded {
            favoritesViewHeightConstraint.constant = self.view.frame.height * 0.20
            favoritesExpanded = true
        } else {
            favoritesViewHeightConstraint.constant = 0.0
            favoritesExpanded = false
        }
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
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
        
        if segue.identifier == "Add Fav Segue" {
            let navVC = segue.destination as! UINavigationController
            if let destVC = navVC.topViewController as? TimerPickerViewController {
                destVC.timerPickerDelegate = self
                destVC.endActionBarButton.title = "Save"
                destVC.nameRequired = true
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
            timer.end()
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
        timer.initTimer()
        
        return cell
        
    }
}

extension TimersViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteTimers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Fav Cell", for: indexPath) as! FavoriteTimerCollectionViewCell
        
        let timer = favoriteTimers.element(atIndex: indexPath.row)
        cell.nameLabel.text = timer.name
        cell.timeLabel.text = TimeConverter.convertToString(fromSeconds: Int(timer.initialTime))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let timer = MTTimer(fromTimer: favoriteTimers.element(atIndex: indexPath.row))
        runningTimers.append(newElement: timer)
        timersTableView.reloadData()
    }
    
    
}

