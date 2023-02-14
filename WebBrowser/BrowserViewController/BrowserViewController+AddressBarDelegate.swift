//
//  BrowserViewController+AddressBarDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 14.02.2023.
//

import UIKit
import WebKit

extension BrowserViewController: AddressBarDelegate {
    func addressBarWillBeginEditing(_ addressBar: AddressBar) {
        guard
            let tabViewController = tabViewControllers[safe: currentTabIndex],
                tabViewController.hasLoadedURl else {
            return
        }
              
        if
            let url = tabViewController.loadingWebpage?.url {
            addressBar.textField.text = url.absoluteString
        }
    }
    
    @objc func addressBar(_ addressBar: AddressBar, didReturnWithText text: String) {
        if let url = browserModel.getURL(for: text) {
            updateWebpageContentModeFor(currentTabController, and: url)
            currentTabController.loadWebsite(from: url)
        }
        dismissKeyboard()
    }
        
    func requestWebpageWith(contentMode: WKWebpagePreferences.ContentMode) { }
    
    func hideToolbar() {
        toolbarIsHide = true
        deactivateToolbar()
    }
    
    func aAButtonMenuWillShow() { }
    
    func aAButtonMenuWillHide() { }
    
    func reloadCurrentWebpage() { }
}
