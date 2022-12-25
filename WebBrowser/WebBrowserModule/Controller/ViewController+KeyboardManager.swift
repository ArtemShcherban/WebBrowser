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
            guard  let self else { return }
            if self.isAddressBarActive {
//                self.webBrowserView.cancelButtonHidden(false)
                
                guard let tabViewController = self.tabViewControllers[safe: self.currentTabIndex]
                else {
                    return
                }
                tabViewController.cancelButtonHidden(false)
                    
                self.animateWithKeyboard(for: notification) { keyboardFrame in
                    self.updateAddressBarStateForKeyboardAppearing(with: keyboardFrame.height)
                }
            } else {
                self.animateWithKeyboard(for: notification) { _ in
                    self.updateDialogBoxStateForKeyboardAppearing()
                }
            }
        }
    }
    
    func setHandlerOnKeyboardWillHide() {
        webBrowserModel.setKeyboardHandlerOnKeyboardWillHide { [weak self] notification in
            guard let self else { return }
            if self.isAddressBarActive {
                self.isAddressBarActive = false
//                self.webBrowserView.cancelButtonHidden(true)
                
                guard let tabViewController = self.tabViewControllers[safe: self.currentTabIndex]
                else {
                    return
                }
                tabViewController.cancelButtonHidden(true)
                                
                self.animateWithKeyboard(for: notification) { _ in
                    self.updateAddressBarStateForKeyboardDisappearing()
                }
            } else {
                self.animateWithKeyboard(for: notification) { _ in
                    self.updateDialogBoxStateForKeyboardDisappearing()
                }
            }
        }
    }
}

private extension ViewController {
    func animateWithKeyboard(for notification: NSNotification, animation: ((CGRect) -> Void)?) {
        guard
            let frame = notification.keyboardEndFrame,
            let duration = notification.keyboardAnimationDuration,
            let curve = notification.keyboardAnimationCurve
        else {
            return
        }
        UIViewPropertyAnimator(duration: duration, curve: curve) {
            animation?(frame)
            self.view.layoutIfNeeded()
        }.startAnimation()
    }
    
    func updateAddressBarStateForKeyboardAppearing(with keyboardHeight: CGFloat) {
        webBrowserView.keyboardBackgroundView.isHidden = false
        let offset = keyboardHeight - webBrowserView.safeAreaInsets.bottom
        webBrowserView.keyboardBackgroundViewBottomConstraint?.constant = -offset + 10
        webBrowserView.addressBarScrollViewBottomConstraint?.constant = -offset
        webBrowserView.addressBarScrollView.isScrollEnabled = false
        tabViewControllers[safe: currentTabIndex]?.showFavoritesView()
        setSideAddressBarsHidden(true)
    }
    
    func updateAddressBarStateForKeyboardDisappearing() {
        webBrowserView.keyboardBackgroundView.isHidden = true
        webBrowserView.keyboardBackgroundViewBottomConstraint?.constant = 0
        webBrowserView.addressBarScrollViewBottomConstraint?.constant =
        webBrowserView.addressBarExpandingFullyBottomOffset
        webBrowserView.addressBarScrollView.isScrollEnabled = true
//        tabViewControllers[safe: currentTabIndex]?.hideFavoritesViewIfNedded()
        setSideAddressBarsHidden(false)
    }
    
    func updateDialogBoxStateForKeyboardAppearing() {
        webBrowserView.dialogBox?.alpha = 1
        webBrowserView.dialogBox?.dialogBoxViewBottomConstraints?.constant = -55
    }
    
    func updateDialogBoxStateForKeyboardDisappearing() {
        webBrowserView.dialogBox?.alpha = 0
        webBrowserView.dialogBox = nil
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
