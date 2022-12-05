//
//  URLValidator.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 05.12.2022.
//

import Foundation

struct URLValidator {
    func isValidURL(_ urlString: String) -> Bool {
        guard
            let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue),
            let match = detector.firstMatch(
                in: urlString,
                range: NSRange(location: 0, length: urlString.utf16.count)
            ) else {
            print("NOT URL")
            return false
        }
        print("THIS IS URL")
        return match.range.length == urlString.utf16.count
    }
}
