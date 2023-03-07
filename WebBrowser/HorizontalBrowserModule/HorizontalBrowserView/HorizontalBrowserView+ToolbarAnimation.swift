//
//  HorizontalBrowserView+ToolbarAnimation.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 21.02.2023.
//

import UIKit

extension HorizontalBrowserView {
    func toolbarFullCollapseAnimation() {
        toolbarTopContstraint?.constant = -52
    }
    
    func toolbarHalfCollapseAnimation() {
        let topOffset: CGFloat = 34
        toolbarTopContstraint?.constant = -topOffset
        addressBarBottomConstraint?.constant = topOffset / 2
        toolbar.items?.forEach { item in
            item.tintColor = .clear
            item.isEnabled = false
        }
        addressBars[0].textField.alpha = 0
        addressBars[0].containerView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    }
    
    func toolbarFullExpandAnimation() {
        addressBars[0].containerView.transform = .identity
        addressBars[0].textField.alpha = 1
        toolbar.items?.forEach { item in
            item.tintColor = .systemBlue
            NotificationCenter.default.post(name: .backForwardStackHasChanged, object: nil)
            toolbarTopContstraint?.constant = 0
            addressBarBottomConstraint?.constant = 0
        }
    }
}
