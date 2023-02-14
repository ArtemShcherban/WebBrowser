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
        controller?.aAButtonMenuWillShow()
    }
    
    func contextMenuWillHide() {
        controller?.aAButtonMenuWillHide()
    }

    func hideToolbarButtonTapped() {
        controller?.hideToolbar()
    }
    
    func versionRequestButtonTapped(with contentMode: WKWebpagePreferences.ContentMode) {
        controller?.requestWebpageWith(contentMode: contentMode)
        textField.aAButton?.setupContextMenu(for: contentMode)
    }
}
