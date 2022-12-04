//
//  ViewController+KeyboardManager.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

extension ViewController {
    func setupKeyboardManager() {
        webBrowserModel.setKeyboardHandler(onKeyboardWillShow: { [weak self] notification in
            guard let self, self.isAddressBarActive else { return }
            self.webBrowserView.cancelButtonHidden(false)
            self.animateWithKeyboard(for: notification) { keyboardFrame in
                self.updateStateForKeyboardAppearing(with: keyboardFrame.height)
            }
        }, onKeyboardWillHide: { [weak self] notification in
            guard let self, self.isAddressBarActive else { return }
            self.isAddressBarActive = false
            self.webBrowserView.cancelButtonHidden(true)
            self.animateWithKeyboard(for: notification) { _ in
                self.updateStateForKeyboardDisappearing()
            }
        })
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
    
    func updateStateForKeyboardAppearing(with keyboardHeight: CGFloat) {
        webBrowserView.keyboardBackgroundView.isHidden = false
        let offset = keyboardHeight - webBrowserView.safeAreaInsets.bottom
        webBrowserView.keyboardBackgroundViewBottomConstraint?.constant = -offset + 10
        webBrowserView.addressBarScrollViewBottomConstraint?.constant = -offset
        webBrowserView.addressBarScrollView.isScrollEnabled = false
        setSideAddressBarsHidden(true)
    }
    
    func updateStateForKeyboardDisappearing() {
        webBrowserView.keyboardBackgroundView.isHidden = true
        webBrowserView.keyboardBackgroundViewBottomConstraint?.constant = 0
        webBrowserView.addressBarScrollViewBottomConstraint?.constant =
        webBrowserView.addressBarExpandingFullyBottomOffset
        webBrowserView.addressBarScrollView.isScrollEnabled = true
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
