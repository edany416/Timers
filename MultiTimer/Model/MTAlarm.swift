//
//  MTAlarm.swift
//  MultiTimer
//
//  Created by edan yachdav on 9/10/18.
//  Copyright © 2018 edan yachdav. All rights reserved.
//

import Foundation
import UserNotifications

class MTAlarm: NSObject, UNUserNotificationCenterDelegate {

    let center = UNUserNotificationCenter.current()
    let uuidStringIdentifier = UUID().uuidString
    var content = UNMutableNotificationContent()

    override init() {
        super.init()
        center.requestAuthorization(options: [.alert, .sound]) { (result, error) in }
        center.delegate = self
        content.title = "Timer(s) Up!"
        content.sound = UNNotificationSound.default
    }
    
    deinit {
        print("Alarm Killed")
        center.removeAllPendingNotificationRequests()
    }
    
    func triggerAlarmAfter(timerInterval seconds: TimeInterval) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        let request = UNNotificationRequest(identifier: uuidStringIdentifier, content: content, trigger: trigger)
        center.add (request) { (error) in
            if error != nil {
                print("There was una problema")
            }
        }
    }
    
    func cancelPendingAlarm() {
        center.removeAllPendingNotificationRequests()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .sound, .badge]) //required to show notification when in foreground
    }
}
