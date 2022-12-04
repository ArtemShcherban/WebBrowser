//
//  KeyboardManager.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

final class KeyboardManager {
    var keyboardWillShowHandler: ((NSNotification) -> Void)?
    var keyboardWillHideHandler: ((NSNotification) -> Void)?
    
    init() {
        addObservers()
    }
}

private extension KeyboardManager {
    func addObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
    }
}

@objc private extension KeyboardManager {
    func keyboardWillShow(_ notification: NSNotification) {
        keyboardWillShowHandler?(notification)
    }
    
    func keyboardWillHide(_ notification: NSNotification) {
        keyboardWillHideHandler?(notification)
    }
}
