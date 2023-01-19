//
//  ViewController+KeyboardManager.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

extension ViewController {
    func setupKeyboardManager() {
        setHandlerOnKeyboardWillShow()
        setHandlerOnKeyboardWillHide()
    }
    
    func setHandlerOnKeyboardWillShow() {
        webBrowserModel.setKeyboardHandlerOnKeyboardWillShow { [weak self] notification in
            guard let self else { return }
            switch self.isAddressBarActive {
            case true:
                self.updateFavoritesViewWithCancellButton(hidden: false)
                self.updateAddressBarStateForKeyboardAppearing(with: notification)
            case false:
                self.webBrowserView.dialogBox?.animateDialogBoaxAppearing(with: notification, view: self.view)
            }
        }
    }
    
    func setHandlerOnKeyboardWillHide() {
        webBrowserModel.setKeyboardHandlerOnKeyboardWillHide { [weak self] notification in
            guard let self else { return }
            switch self.isAddressBarActive {
            case true:
                self.isAddressBarActive = false
                self.updateFavoritesViewWithCancellButton(hidden: true)
                self.updateAddressBarStateForKeyboardDisappearing(with: notification)
            case false:
                self.webBrowserView.dialogBox?.animateDialogBoxDisappearing(
                    with: notification,
                    view: self.view
                ) {
                    self.webBrowserView.dialogBox = nil
                }
            }
        }
    }
}

private extension ViewController {
    func updateFavoritesViewWithCancellButton(hidden: Bool) {
        guard let tabViewController = self.tabViewControllers[safe: self.currentTabIndex]
        else { return }
        tabViewController.cancelButton(isHidden: false)
        tabViewController.finishEditingModeIfNeeded()
    }
    
    func updateAddressBarStateForKeyboardAppearing(with notification: NSNotification) {
        webBrowserView.animateAddressBarMovingUpwards(with: notification, and: self.view)
        currentAddressBar.animateDomainLabelExtension(with: notification, view: self.view)
        tabViewControllers[safe: currentTabIndex]?.showFavoritesView()
        setSideAddressBarsHidden(true)
    }
    
    func updateAddressBarStateForKeyboardDisappearing(with notification: NSNotification) {
        webBrowserView.animateAddressBarMovingDownwards(with: notification, view: self.view)
        currentAddressBar.animateDomainLabelCollapsing(with: notification, view: self.view)
        setSideAddressBarsHidden(false)
    }
    
    func setSideAddressBarsHidden(_ isHidden: Bool) {
        if let leftAddressBar {
            setHidden(isHidden, forLeftAddressBar: leftAddressBar)
        }
        if let rightAddressBar {
            setHidden(isHidden, forRightAddressBar: rightAddressBar)
        }
    }
    
    func setHidden(_ isHidden: Bool, forRightAddressBar addressBar: AddressBar) {
        // In some cases keyboard willShow is called multiple times.
        // To prevent the address bar center from being offset multiple times we have to check if it is already offset
        if isHidden && addressBar.alpha == 0 {
            return
        }
        
        let offset = webBrowserView.addressBarHiddingCenterOffset
        if isHidden {
            addressBar.center = CGPoint(
                x: addressBar.center.x + offset,
                y: addressBar.center.y - offset
            )
        } else {
            addressBar.center = CGPoint(
                x: addressBar.center.x - offset,
                y: addressBar.center.y + offset
            )
        }
        addressBar.alpha = isHidden ? 0 : 1
    }
    
    func setHidden(_ isHidden: Bool, forLeftAddressBar addressBar: AddressBar) {
        if isHidden && addressBar.alpha == 0 {
            return
        }
        
        let offset = webBrowserView.addressBarHiddingCenterOffset
        if isHidden {
            addressBar.center = CGPoint(
                x: addressBar.center.x - offset,
                y: addressBar.center.y - offset
            )
        } else {
            addressBar.center = CGPoint(
                x: addressBar.center.x + offset,
                y: addressBar.center.y + offset
            )
        }
        addressBar.alpha = isHidden ? 0 : 1
    }
}
