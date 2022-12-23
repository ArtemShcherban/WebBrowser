//
//  URLGenerator.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 04.12.2022.
//

import UIKit

final class URLGenerator {
    private let urlValidator: URLValidator
    
    init(urlValidator: URLValidator = .init()) {
        self.urlValidator = urlValidator
    }
    
    func getURL(for text: String) -> URL? {
        let text = text.lowercased()
        guard urlValidator.isValidURL(text) else {
            return googleSearchURL(for: text)
        }
        guard text.hasPrefix("http://") || text.hasPrefix("https://") else {
            return URL(string: "https://\(text)")
        }
        return URL(string: text)
    }
    
    private func googleSearchURL(for text: String) -> URL? {
        guard let encodedString = text.addingPercentEncoding(
            withAllowedCharacters: .urlFragmentAllowed
        ) else { return nil }
        let queryString = "https://www.google.com/search?q=\(encodedString)"
        return URL(string: queryString)
    }
}
