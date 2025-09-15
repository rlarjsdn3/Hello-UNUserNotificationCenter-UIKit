//
//  AppDelegate.swift
//  SlientPushDemo
//
//  Created by 김건우 on 9/15/25.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let center = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
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
    
    private func requestUserNotificationAuthorization() async throws {
        try await center.requestAuthorization(options: [.alert, .badge, .sound])
    }
    
    private func registerForRemoteNotifications() {
        Task {
            do {
                try await requestUserNotificationAuthorization()
                let settings = await center.notificationSettings()
                print("푸시 알림 권한 승인됨:", settings.authorizationStatus == .authorized)
                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            } catch {
                // Handle error here..
            }
        }
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
        // 일정 시간 후, 다시 디바이스 토큰 요청
    }
    
    nonisolated func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any]
    ) async -> UIBackgroundFetchResult {
        let gameName = userInfo["gameName"] as? String
        
        await MainActor.run {
            if let gameName {
                NotificationCenter.default.post(
                    name: .newGameArrived,
                    object: nil,
                    userInfo: ["gameName": gameName]
                )
            }
        }
        
        return .newData
    }
}

