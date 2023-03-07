//
//  BrowserViewController+KeyboardManager.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 13.02.2023.
//

import UIKit

extension BrowserViewController {
    func setupKeyboardManager() {
        setHandlerOnKeyboardWillShow()
        setHandlerOnKeyboardWillHide()
    }
    
    private func setHandlerOnKeyboardWillShow() {
        browserModel.setKeyboardHandlerOnKeyboardWillShow { [weak self] notification in
            guard let self else { return }
            switch self.currentAddressBar.isActive {
            case true:
                self.updateAddressBarStateForKeyboardAppearing(with: notification)
            case false:
                self.browserView.dialogBox?.animateDialogBoxAppearing(with: notification, view: self.view)
            }
        }
    }
    
    private func setHandlerOnKeyboardWillHide() {
        browserModel.setKeyboardHandlerOnKeyboardWillHide { [weak self] notification in
            guard let self else { return }
            switch self.currentAddressBar.isActive {
            case true:
                self.currentAddressBar.isActive = false
                self.updateAddressBarStateForKeyboardDisappearing(with: notification)
            case false:
                self.browserView.dialogBox?.animateDialogBoxDisappearing(
                    with: notification,
                    view: self.view,
                    completion: {
                        self.browserView.dialogBox = nil
                    })
            }
        }
    }
    
    @objc func updateAddressBarStateForKeyboardAppearing(with notification: NSNotification) {
        currentAddressBar.animateDomainLabelExtension(with: notification, view: self.view)
        tabViewControllers[safe: currentTabIndex]?.showFavoritesView()
    }
    
    @objc func updateAddressBarStateForKeyboardDisappearing(with notification: NSNotification) {
        currentAddressBar.animateDomainLabelCollapsing(with: notification, view: self.view)
    }
}
