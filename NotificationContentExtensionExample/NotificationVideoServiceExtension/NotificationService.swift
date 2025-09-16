//
//  NotificationService.swift
//  NotificationImageContentServiceExtension
//
//  Created by 김건우 on 9/15/25.
//

import Foundation
import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    private typealias ContentHandler = ((UNNotificationContent) -> Void)

    private let downloader = Downloader()

    private var contentHandler: ContentHandler?
    private var bestAttemptContent: UNMutableNotificationContent?

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        self.bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)

        let categoryIdentifier = request.content.categoryIdentifier

        switch categoryIdentifier {
        case "PLACEHOLDER_VIDEO":
            handleVideoNotificationContent(request, withContentHandler: contentHandler)
        case "PLACEHOLDER_IMAGES":
            handleImagesNotificationContent(request, withContentHandler: contentHandler)
        default:
            break
        }
    }

    override func serviceExtensionTimeWillExpire() {

        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }

}

extension NotificationService {

    private func handleVideoNotificationContent(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping ContentHandler
    ) {

        let userInfo = request.content.userInfo

        if let bestAttemptContent = bestAttemptContent,
           let videoURL = userInfo["video-url"] as? String {
            Task {
                do {
                    let destURL = try await downloader.download(from: URL(string: videoURL)!, filenName: "video.mp4")

                    let attachment = try UNNotificationAttachment(
                        identifier: "placeholder-video",
                        url: destURL
                    )
                    bestAttemptContent.attachments = [attachment]
                    contentHandler(bestAttemptContent)
                } catch {
                    // do something..
                }
            }
        }
    }

    private func handleImagesNotificationContent(
        _ request: UNNotificationRequest,
        withContentHandler contentHandler: @escaping ContentHandler
    ) {

        let userInfo = request.content.userInfo

        if let bestAttemptContent = bestAttemptContent,
           let images = userInfo["image-urls"] as? [String] {
            Task {
                do {
                    async let image1 = try await downloader.download(from: URL(string: images[0])!, filenName: "image-1.png")
                    async let image2 = try await downloader.download(from: URL(string: images[1])!, filenName: "image-2.png")
                    async let image3 = try await downloader.download(from: URL(string: images[2])!, filenName: "image-3.png")

                    let (img1, img2, img3) = try await (image1, image2, image3)

                    let attachment1 = try UNNotificationAttachment(
                        identifier: "image-1",
                        url: img1
                    )
                    let attachment2 = try UNNotificationAttachment(
                        identifier: "image-2",
                        url: img2
                    )
                    let attachment3 = try UNNotificationAttachment(
                        identifier: "image-3",
                        url: img3
                    )
                    bestAttemptContent.attachments = [
                        attachment1,
                        attachment2,
                        attachment3
                    ]
                    contentHandler(bestAttemptContent)
                } catch {
                    // do something..
                }
            }
        }
    }
}
