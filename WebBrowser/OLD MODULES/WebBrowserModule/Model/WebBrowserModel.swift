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
    
    func setKeyboardHandlerOnKeyboardWillShow(keyboardWillShowHandler: ((NSNotification) -> Void)?) {
        keyboardManager.keyboardWillShowHandler = keyboardWillShowHandler
    }
    
    func setKeyboardHandlerOnKeyboardWillHide(keyboardWillHideHandler: ((NSNotification) -> Void)?) {
        keyboardManager.keyboardWillHideHandler = keyboardWillHideHandler
    }
    
    func getURL(for text: String) -> URL? {
        urlGenerator.getURL(for: text)
    }
    
    func getDomain(from url: URL) -> String {
        var domainLabelTitle = String()
        
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
