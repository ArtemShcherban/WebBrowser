//
//  BrowserViewModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 13.02.2023.
//

import UIKit

class BrowserModel {
    private let keyboardManager: KeyboardManager
    private let urlGenerator: URLGenerator
    
    init(
        keyboardManager: KeyboardManager = .init(),
        urlGenerator: URLGenerator = .init()
    ) {
        self.keyboardManager = keyboardManager
        self.urlGenerator = urlGenerator
    }
    
    func setKeyboardHandlerOnKeyboardWillShow(keyboardWillShowHandler: ((NSNotification) -> Void)?) {
        keyboardManager.keyboardWillShowHandler = keyboardWillShowHandler
    }
    
    func setKeyboardHandlerOnKeyboardWillHide(keyboardWillHideHandler: ((NSNotification) -> Void)?) {
        keyboardManager.keyboardWillHideHandler = keyboardWillHideHandler
    }
    
    func getURL(for text: String) -> URL? {
        urlGenerator.getURL(for: text)
    }
    
    func getDomain(from url: URL?) -> String {
        var domainLabelTitle = String()
        guard let url else { return domainLabelTitle }
        
        if let host = url.host {
            domainLabelTitle = host
        } else {
            domainLabelTitle = url.absoluteString
        }
        
        if domainLabelTitle.hasPrefix("www.") {
            domainLabelTitle.removeFirst(4)
        }
        return domainLabelTitle
    }
}
