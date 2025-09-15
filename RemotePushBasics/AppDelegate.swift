//
//  AppDelegate.swift
//  RemotePushBasics
//
//  Created by 김건우 on 9/13/25.
//

import UIKit
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        setNotificationCategories()
        registerForRemoteNotifications()

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

    private func registerForRemoteNotifications() {
        UNUserNotificationCenter.current().delegate = self

        let options: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
            print("푸시 알림 권한이 승인됨: \(granted)")
            //
            guard granted else { return }
            //
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    private func setNotificationCategories() {
        let accept = UNNotificationAction(
            identifier: "ACCEPT_ACTION",
            title: "Accept",
            options: []
        )
        let decline = UNNotificationAction(
            identifier: "DECLINE_ACTION",
            title: "Decline",
            options: []
        )
        let category = UNNotificationCategory(
            identifier: "GAME_INVITATION",
            actions: [accept, decline],
            intentIdentifiers: [],
            hiddenPreviewsBodyPlaceholder: "",
            options: .customDismissAction
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([category])
    }
}

extension AppDelegate {

    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        // 1. 디바이스 토큰을 문자열로 변환
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        // 2. 개인 서버(provider server)로 토큰 전송
        print("Device Token: \(token)")
    }

    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: any Error
    ) {
        // 토큰 발급 실패 시, 일정 시간이 지난 후 재시도
    }
}

extension AppDelegate {
    
    func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void
    ) {
        let gameID = userInfo["gameID"] as! String
        
        // ...
        
        completionHandler(.newData)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
}
