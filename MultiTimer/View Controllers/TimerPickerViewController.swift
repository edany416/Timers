//
//  TimerPickerViewController.swift
//  MultiTimer
//
//  Created by edan yachdav on 12/27/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit

protocol TimerPickerDelegate {
    func timerCreated(_ timer: MTTimer)
}

class TimerPickerViewController: UIViewController {
    
    @IBOutlet weak var timerPickerView: UIPickerView!
    @IBOutlet weak var timerNameTextField: UITextField!
    @IBOutlet weak var endActionBarButton: UIBarButtonItem!
    
    var timerPickerDelegate: TimerPickerDelegate?
    var nameRequired = false
    
    private var timer: MTTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerPickerView.dataSource = self
        timerPickerView.delegate = self
        timerNameTextField.becomeFirstResponder()
    }
    
    private var hours: Int { return timerPickerView.selectedRow(inComponent: Constants.HourComponent) }
    private var minutes: Int { return timerPickerView.selectedRow(inComponent: Constants.MinuteComponent) }
    private var seconds: Int { return timerPickerView.selectedRow(inComponent: Constants.SecondsComponent) }
    
    private func timerSet() -> Bool {
        if nameRequired && timerNameTextField.text == "" {
            return false
        }
        if (hours == 0) && (minutes == 0) && (seconds == 0) {
            return false
        }
        return true
    }
    
    @IBAction func rightBarButtonTapped(_ sender: Any) {
        if timerSet() {
            if let delegate = self.timerPickerDelegate {
                let totalTimeInSeconds = TimeConverter.convertToSeconds(fromHours: self.hours, minutes: self.minutes, seconds: self.seconds)
                delegate.timerCreated(MTTimer(fromTimeInterval: totalTimeInSeconds, name: self.timerNameTextField.text))
            }
            timerNameTextField.resignFirstResponder()
            timerPickerDelegate = nil
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Missing Data", message: "Some required data is missing", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    @IBAction func cancelButtonTapped(_ sender: Any) {
        timerNameTextField.resignFirstResponder()
        dismiss(animated: true, completion: nil)
        timerPickerDelegate = nil
    }
}

extension TimerPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    // Mark - picker view methods
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return Constants.PickerViewComponents
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case Constants.HourComponent:
            return Constants.Hours
        case Constants.MinuteComponent:
            return Constants.Minutes
        case Constants.SecondsComponent:
            return Constants.Seconds
        default:
            break
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = "\(row)"
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.foregroundColor:UIColor.white])
        return myTitle
    }
}
