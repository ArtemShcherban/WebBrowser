//
//  DialogBoxTextField.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 12.12.2022.
//

import UIKit

class DialogBoxTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if
            action == #selector(UIResponderStandardEditActions.cut(_:)) ||
            action == #selector(UIResponderStandardEditActions.copy(_:)) ||
            action == #selector(UIResponderStandardEditActions.select(_:)) {
            return true
        } else {
            return false
        }
    }
}
