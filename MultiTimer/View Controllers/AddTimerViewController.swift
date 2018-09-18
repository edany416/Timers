//
//  AddTimerViewController.swift
//  MultiTimer
//
//  Created by edan yachdav on 8/29/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import UIKit

class AddTimerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var timerPickerView: UIPickerView!
    @IBOutlet weak var timerNameTextField: UnderlineTextField!
    var timer: MTTimer?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerPickerView.dataSource = self
        timerPickerView.delegate = self
        timerNameTextField.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timerNameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        timerNameTextField.resignFirstResponder()
        return true
    }
    
    @objc private func dismissKeyboardWithTap() {
        _ = textFieldShouldReturn(timerNameTextField)
    }
    
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
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.foregroundColor:UIColor.white])
        return myTitle
    }
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private var hours: Int { return timerPickerView.selectedRow(inComponent: Constants.HourComponent) }
    private var minutes: Int { return timerPickerView.selectedRow(inComponent: Constants.MinuteComponent) }
    private var seconds: Int { return timerPickerView.selectedRow(inComponent: Constants.SecondsComponent) }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (hours == 0) && (minutes == 0) && (seconds == 0) {
            return false
        }
        return true
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueID = segue.identifier, segueID == "Unwind Start" {
            let totalTimeInSeconds = TimeConverter.convertToSeconds(fromHours: hours, minutes: minutes, seconds: seconds)
            timer = MTTimer(fromTimeInterval: totalTimeInSeconds, name: timerNameTextField.text)
        }
    }
}
