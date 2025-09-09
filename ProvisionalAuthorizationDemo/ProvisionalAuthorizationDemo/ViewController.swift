//
//  ViewController.swift
//  ProvisionalAuthorizationDemo
//
//  Created by 김건우 on 9/8/25.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBAction func provisionalAuthtorizationButtonTapped(_ sender: Any) {
        Task {
            await requestUNUserNotificationAuthroization()
            await scheduleUNUserNotificationRequest()

            let status = await currentNotificationAuthorizationStatus()
            print("현재 알림 권한 설정 상태: \(status)")
        }
    }

    private func requestUNUserNotificationAuthroization() async {
        let center = UNUserNotificationCenter.current()

        do {
            // 알림 임시 권한 요청
            try await center.requestAuthorization(options: [.alert, .sound, .badge, .provisional])
        } catch {
            // Handle error here.
        }
    }

    private func scheduleUNUserNotificationRequest() async {
        let content = UNMutableNotificationContent()
        content.title = "Provisional Authorization Demo"
        content.body = "This is a provisional authorization demo notification."
        content.badge = 1

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 3,
            repeats: false
        )
        let request = UNNotificationRequest(
            identifier: "devxoul.provisional-authorization-demo",
            content: content,
            trigger: trigger
        )

        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            // Handle error here.
        }
    }

    private func currentNotificationAuthorizationStatus() async -> UNAuthorizationStatus {
        let center = UNUserNotificationCenter.current()

        // 알림 설정 정보 불러오기
        let settings = await center.notificationSettings()
        return settings.authorizationStatus
    }

}

