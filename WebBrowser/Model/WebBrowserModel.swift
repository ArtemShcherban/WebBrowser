//
//  WebBrowserModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

class WebBrowserModel {
    private let keyboardManager: KeyboardManager
    
    init(keyboardManager: KeyboardManager = .init()) {
        self.keyboardManager = keyboardManager
    }
    
    func setKeyboardHandler(
        onKeyboardWillShow keyboardWillShowHandler: ((NSNotification) -> Void)?,
        onKeyboardWillHide keyboardWillHideHandler: ((NSNotification) -> Void)?
    ) {
        keyboardManager.keyboardWillShowHandler = keyboardWillShowHandler
        keyboardManager.keyboardWillHideHandler = keyboardWillHideHandler
    }
}
