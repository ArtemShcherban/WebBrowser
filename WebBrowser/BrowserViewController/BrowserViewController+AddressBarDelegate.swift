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
        
    func requestWebsiteWith(contentMode: WKWebpagePreferences.ContentMode) {
        let tabViewController = tabViewControllers[safe: currentTabIndex]
        tabViewController?.updateWebViewConfiguration(with: contentMode)
    }
    
    func hideToolbar() {
        toolbarIsHide = true
        deactivateToolbar()
    }
    
    func aAButtonMenuWillShow() {
        browserView.disableToolbarButtons()
    }
    
    func aAButtonMenuWillHide() {
        updateToolbarButtons()
    }
    
    func reloadCurrentWebsite() {
        let tabViewController = tabViewControllers[safe: currentTabIndex]
        tabViewController?.reload()
    }
}
