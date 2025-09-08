//
//  ViewController.swift
//  LocalNotificationsBasics
//
//  Created by 김건우 on 9/8/25.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet weak var notificationsTableView: UITableView!

    private var pendingNotifications: [UNNotificationRequest] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "NSUserNotifications"
        navigationItem.subtitle = "Local Notifications Basics"
    }

    @IBAction func addLocalNotification(_ sender: Any) {
        Task {
            await requestNotificationAuthorization()
            await scheduleUNUserNotificationRequest()
        }
    }

    private func requestNotificationAuthorization() async {
        let center = UNUserNotificationCenter.current()

        do {
            try await center.requestAuthorization(options: [.alert, .sound, .badge])
        } catch {
            // Handle the error here.
        }

        // Enable or disable features based on the authorization.
    }

    private func scheduleUNUserNotificationRequest(after timeInterval: TimeInterval = 3) async {
        // #1. 알림 콘텐츠 생성 및 설정
        let content = UNMutableNotificationContent()
        content.title = "NSUserNotifications"
        content.body = "Local Notificaitons Basics"
        content.userInfo = ["customData": "Hello, UNUserNotifications!"] // 커스텀 데이터 전달
        content.badge = 777 // 앱 아이콘 뱃지 숫자 설정

        let imageUrl = Bundle.main.url(forResource: "whitey", withExtension: "jpg")!
        if let attachment = try? UNNotificationAttachment(identifier: "dev.image.whitey", url: imageUrl) {
            content.attachments = [attachment] // 알림창에 이미지 첨부
        }

        let soundName = UNNotificationSoundName("ringtone.mp3")
        content.sound = UNNotificationSound(named: soundName) // 사용자 정의 사운드 지정

        content.categoryIdentifier = "CATEOGRY_IDENTIFIER" // 알림 카테고리 식별자 지정
        content.threadIdentifier = "THREAD_IDENTIFIER"     // 알림 스레드(그룹) 식별자 지정

        // #2. 알림 트리거 설정 (현재 시각 기준으로 몇 초 뒤 실행)
        let nowAfterFewSeconds = Date(timeIntervalSinceNow: timeInterval)
        let comps = Calendar.current.dateComponents(
            [.minute, .second],
            from: nowAfterFewSeconds
        )

        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)

        // #3. 알림 요청 객체 생성
        let request = UNNotificationRequest(
            identifier: "dev.sindresorhus.UNUserNotifications-Basics",
            content: content,
            trigger: trigger
        )

        // #4. 알림 요청을 Notification Center에 등록
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {
            // Handle the error here.
        }

        // 새 요청을 추가한 뒤, 보류 중인 알림 리스트를 UI에 반영
        reconfigureTableView(with: request)
    }
}

extension ViewController {

    private func reconfigureTableView(with request: UNNotificationRequest) {
        pendingNotifications.append(request)
        notificationsTableView.insertRows(
            at: [IndexPath(row: pendingNotifications.count - 1, section: 0)],
            with: .automatic
        )
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return pendingNotifications.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        var contentConfig = cell.defaultContentConfiguration()
        let noti = pendingNotifications[indexPath.row]
        contentConfig.text = noti.content.title
        contentConfig.secondaryText = noti.identifier
        cell.contentConfiguration = contentConfig
        return cell
    }

    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        let noti = pendingNotifications[indexPath.row]

        if editingStyle == .delete {
            let indices = pendingNotifications.indices(where: { $0.identifier == noti.identifier })
            indices.sorted(by: >).forEach { pendingNotifications.remove(at: $0) }

            let indexPaths = indices.map { IndexPath(row: $0, section: 0) }
            tableView.deleteRows(at: indexPaths, with: .automatic)

            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [noti.identifier])
        }
    }

    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        return "Pending Notifications"
    }
}


fileprivate extension Array {

    func indices(where predicate: (Element) throws -> Bool) rethrows -> [Int] {
        var indices: [Int] = []
        try self.enumerated().forEach { offset, element in
            if try predicate(element) {
                indices.append(offset)
            }
        }
        return indices
    }
}
