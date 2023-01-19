//
//  WebBrowserView+Animation.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 14.01.2023.
//

import UIKit

extension WebBrowserView {
    func animateAddressBarMovingUpwards(with notification: NSNotification, and view: UIView) {
        let animator = AnimatorFactory.animateWithKeyboard(
            for: notification,
            view: view,
            animation: ({ keyboardFrame in
                self.animateAddressBarStateUpdating(for: keyboardFrame.height)()
            })
        )
        animator?.startAnimation()
    }
    
    func animateAddressBarMovingDownwards(with notification: NSNotification, view: UIView) {
        let animator = AnimatorFactory.animateWithKeyboard(
            for: notification,
            view: view,
            animation: ({ _ in
                self.animateAddressBarStateUpdating()
            }))
        animator?.startAnimation()
    }
    
    private func animateAddressBarStateUpdating(for keyboardHeight: CGFloat) -> (() -> Void) {
        return {
            self.keyboardBackgroundView.isHidden = false
            self.addressBarScrollView.isScrollEnabled = false
            let offset = keyboardHeight - self.safeAreaInsets.bottom
            self.keyboardBackgroundViewBottomConstraint?.constant = -offset + 10
            self.addressBarScrollViewBottomConstraint?.constant = -offset
        }
    }
    
    private func animateAddressBarStateUpdating() {
        keyboardBackgroundView.isHidden = true
        keyboardBackgroundViewBottomConstraint?.constant = 0
        addressBarScrollViewBottomConstraint?.constant =
        addressBarExpandingFullyBottomOffset
        addressBarScrollView.isScrollEnabled = true
    }
}
