//
//  AddressBar+AaButtonDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 19.01.2023.
//

import UIKit
import WebKit

extension AddressBar: AaButtonDelegate {
    func contextMenuWillShow() {
        delegate?.aAButtonMenuWillShow()
    }
    
    func contextMenuWillHide() {
        delegate?.aAButtonMenuWillHide()
    }

    func hideToolbarButtonTapped() {
        delegate?.hideToolbar()
    }
    
    func versionRequestButtonTapped(with contentMode: WKWebpagePreferences.ContentMode) {
        delegate?.requestWebpageWith(contentMode: contentMode)
        textField.aAButton?.setupContextMenu(for: contentMode)
    }
}
