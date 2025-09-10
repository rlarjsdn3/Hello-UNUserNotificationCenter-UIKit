//
//  AppDelegate.swift
//  ActionableUserNotifications
//
//  Created by 김건우 on 9/10/25.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        registerUserNotificationCategories()
        UNUserNotificationCenter.current().delegate = self
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension AppDelegate {
    
    private func registerUserNotificationCategories() {
        let normalCateogry = createNormalUserNotifictionCategory()
        let textInputCategory = createTextInputUserNotificationCategory()
        UNUserNotificationCenter.current().setNotificationCategories([normalCateogry, textInputCategory])
    }
    
    private func createNormalUserNotifictionCategory() -> UNNotificationCategory {
        let accept = UNNotificationAction(
            identifier: "ACCEPT_ACTION",
            title: "Accept",
            options: [.authenticationRequired]
        )
        let decline = UNNotificationAction(
            identifier: "DECLINE_ACTION",
            title: "Decline",
            options: []
        )
        let category = UNNotificationCategory(
            identifier: "NORMAL_NOTIFICATION_CATEGORY",
            actions: [accept, decline],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: []
        )
        return category
    }
    
    private func createTextInputUserNotificationCategory() -> UNNotificationCategory {
        let cancel = UNNotificationAction(
            identifier: "CANCEL_ACTION",
            title: "Cancel",
            options: []
        )
        let textInput = UNTextInputNotificationAction(
            identifier: "TEXT_INPUT_ACTION",
            title: "Enter your name here..",
            options: []
        )
        let category = UNNotificationCategory(
            identifier: "TEXT_INPUT_NOTIFICATION_CATEGORY",
            actions: [cancel, textInput],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: []
        )
        return category
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        let userInfo = notification.request.content.userInfo
        
        if notification.request.content.categoryIdentifier == "NORMAL_NOTIFICATION_CATEGORY" {
            let userID = userInfo["userID"] as! String
            let meetingID = userInfo["meetingID"] as! String
            
            print(#function, "- categoryIdentifier: NORMAL_NOTIFICATION_CATEGORY")
            // 포그라운드 상태에서 NORMAL_NOTIFICATION_CATEGORY 알림 수신 시, 적절한 로직을 처리하기
            
            completionHandler(.sound) // 알림 수신 시, 사용자에게 사운드로 알려주기
            return
        }
        else {
            // 다른 알림 수신 시, 무시하기
        }
        
        completionHandler(UNNotificationPresentationOptions(rawValue: 0))
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        if response.notification.request.content.categoryIdentifier == "NORMAL_NOTIFICATION_CATEGORY" {
            let userID = userInfo["userID"] as! String
            let meetingID = userInfo["meetingID"] as! String

            switch response.actionIdentifier {
            case "ACCEPT_ACTION":
                print(#function, "- ACCEPT_ACTION")

            case "DECLINE_ACTION":
                print(#function, "- DECLINE_ACTION")

            default:
                break
            }
        }
        else { // TEXT_INPUT_NOTIFICATION_CATEGORY
            guard let response = response as? UNTextInputNotificationResponse
            else { return }
            print(#function, response.userText, "- TEXT_INPUT_ACTION")
        }

        completionHandler()
    }
    
}

