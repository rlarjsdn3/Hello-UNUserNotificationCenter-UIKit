//
//  NotificationViewController.swift
//  NotificationImageContentExtension
//
//  Created by 김건우 on 9/15/25.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet var imageViews: [UIImageView]!

    func didReceive(_ notification: UNNotification) {
        let attachments = notification.request.content.attachments

        for (offset, attachment) in attachments.enumerated() {
            let destinationURL = attachment.url
            guard destinationURL.startAccessingSecurityScopedResource() else { continue }
            defer { destinationURL.stopAccessingSecurityScopedResource() }

            if let imageData = try? Data(contentsOf: destinationURL) {
                imageViews[offset].image = UIImage(data: imageData)
            }
        }
    }

}
