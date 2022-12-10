//
//  WebBrowserModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

class WebBrowserModel {
    private let keyboardManager: KeyboardManager
    private let urlGenerator: URLGenerator
    
    init(
        keyboardManager: KeyboardManager = .init(),
        urlGenerator: URLGenerator = .init()
    ) {
        self.keyboardManager = keyboardManager
        self.urlGenerator = urlGenerator
    }
    
    func setKeyboardHandler(
        onKeyboardWillShow keyboardWillShowHandler: ((NSNotification) -> Void)?,
        onKeyboardWillHide keyboardWillHideHandler: ((NSNotification) -> Void)?
    ) {
        keyboardManager.keyboardWillShowHandler = keyboardWillShowHandler
        keyboardManager.keyboardWillHideHandler = keyboardWillHideHandler
    }
    
    func getURL(for text: String) -> URL? {
        urlGenerator.getURL(for: text)
    }
    
    func getDomain(from url: URL) -> String {
        guard var domain = url.host else { return url.absoluteString }
        if domain.hasPrefix("www.") {
            domain.removeFirst(4)
        }
        return domain
    }
}
