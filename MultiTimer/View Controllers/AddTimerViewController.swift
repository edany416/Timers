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
    
    // Mark: picker view methods
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
    
    // Mark: Action methods
    @IBAction func startButtonTapped(_ sender: Any) {
        let hours = timerPickerView.selectedRow(inComponent: Constants.HourComponent)
        let minutes = timerPickerView.selectedRow(inComponent: Constants.MinuteComponent)
        let seconds = timerPickerView.selectedRow(inComponent: Constants.SecondsComponent)
        let time = MTTime(fromHours: hours, minutes: minutes, seconds: seconds)
        timer = MTTimer(withTime: time, andName: timerNameTextField.text)
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueID = segue.identifier, segueID == "Unwind Start" {
            let hours = timerPickerView.selectedRow(inComponent: Constants.HourComponent)
            let minutes = timerPickerView.selectedRow(inComponent: Constants.MinuteComponent)
            let seconds = timerPickerView.selectedRow(inComponent: Constants.SecondsComponent)
            let time = MTTime(fromHours: hours, minutes: minutes, seconds: seconds)
            timer = MTTimer(withTime: time, andName: timerNameTextField.text)
        }
    }
}
