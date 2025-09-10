//
//  ViewController.swift
//  ActionableUserNotifications
//
//  Created by 김건우 on 9/10/25.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        Task {
            do {
                try await center.requestAuthorization(options: [.alert, .sound, .badge])
            } catch {
                // Handle error here...
            }
        }
    }
    
    @IBAction func normalActionableNotificationTapped(_ sender: Any) {
        Task { await scheduleActionableNotificationRequest() }
    }
    
    @IBAction func textInputActionableNotificationTapped(_ sender: Any) {
        Task { await scheduleTextInputActionableNotificationRequest() }
    }
    
    private func scheduleActionableNotificationRequest() async {
        let content = UNMutableNotificationContent()
        content.title = "Actionable Notification"
        content.body = "Tap to view details"
        content.userInfo = ["userID": "12345", "meetingID": "abcde"]
        content.categoryIdentifier = "NORMAL_NOTIFICATION_CATEGORY" //
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "ACTIONABLE_NOTIFICATION_REQUEST",
            content: content,
            trigger: trigger
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            // Handle error here...
        }
    }
    
    private func scheduleTextInputActionableNotificationRequest() async {
        let content = UNMutableNotificationContent()
        content.title = "Text Input Actionable Notification"
        content.body = "Please enter your name"
        content.userInfo = ["userID": "12345", "meetingID": "abcde"]
        content.categoryIdentifier = "TEXT_INPUT_NOTIFICATION_CATEGORY"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "TEXT_INPUT_ACTIONABLE_NOTIFICATION_REQUEST",
            content: content,
            trigger: trigger
        )
        
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            // Handle error here...
        }
    }
}

