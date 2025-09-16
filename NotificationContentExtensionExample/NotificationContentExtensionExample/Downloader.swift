//
//  Downloader.swift
//  NotificationContentExtensionExample
//
//  Created by 김건우 on 9/15/25.
//

import Foundation

final class Downloader {

    func download(from url: URL, filenName: String) async throws -> URL {
        let (url, response) = try await URLSession.shared.download(from: url)
        guard let httpResponse = (response as? HTTPURLResponse),
              200..<300 ~= httpResponse.statusCode
        else { throw URLError(.badServerResponse) }

        return try save(from: url, fileName: filenName)
    }
}

private extension Downloader {

    func save(
        from url: URL,
        to destDir: URL = FileManager.default.temporaryDirectory,
        fileName name: String
    ) throws -> URL {
        let fileManager = FileManager.default

        let destinationURL = destDir.appending(path: name)
        if fileManager.fileExists(atPath: destinationURL.path()) {
            try fileManager.removeItem(at: destinationURL)
        }

        let data = try Data(contentsOf: url)
        try data.write(to: destinationURL)
        return destinationURL
    }
}
