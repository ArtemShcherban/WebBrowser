//
//  VerticalBrowserView+ToolbarAnimation.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 19.02.2023.
//

import UIKit

extension VerticalBrowserView {
    func toolbarHalfCollapseAnimation() {
        self.setAddressBarContainersAlpha(0.0)
        self.addressBarScrollViewBottomConstraint?.constant =
        self.addressBarCollapsingHalfwayBottomOffset
        self.toolbarBottomConstraint?.constant =
        self.toolbarCollapsingHalfwayBottomOffset
    }
    
    func toolbarFullCollapseAnimation() {
        self.addressBarScrollViewBottomConstraint?.constant =
        self.addressBarCollapsingFullyBottomOffset
        self.toolbarBottomConstraint?.constant =
        self.toolbarCollapsingFullyBottomOffset
    }
    
    func addressBarScalingDownAnimation() {
        guard let controller = controller as? VerticalBrowserController else { return }
        controller.currentAddressBar.domainLabel.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        controller.leftAddressBar?.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 0.8)
        controller.rightAddressBar?.containerView.transform = CGAffineTransform(scaleX: 1.0, y: 0.8)
        self.addressBarScrollView.isScrollEnabled = false
    }
    
    func toolbarHalfExpandAnimation() {
        addressBarScrollViewBottomConstraint?.constant =
        addressBarExpandingHalfwayBottomOffset
        toolbarBottomConstraint?.constant =
        toolBarExpandingHalfwayBottomOffset
    }
    
    func toolbarFullExpandAnimation() {
        self.addressBarScrollViewBottomConstraint?.constant =
        self.addressBarExpandingFullyBottomOffset
        self.toolbarBottomConstraint?.constant =
        self.toolBarExpandingFullyBottomOffset
    }
    
    func addressBarScalingUpAnimation() {
        guard let controller = controller as? VerticalBrowserController else { return }
        setAddressBarContainersAlpha(1.0)
        controller.currentAddressBar.domainLabel.transform = .identity
        controller.leftAddressBar?.containerView.transform = .identity
        controller.rightAddressBar?.containerView.transform = .identity
        self.addressBarScrollView.isScrollEnabled = true
    }
    
    private func setAddressBarContainersAlpha(_ alpha: CGFloat) {
        guard let controller = controller as? VerticalBrowserController else { return }
        controller.currentAddressBar.textField.alpha = alpha
        controller.currentAddressBar.shadowView.alpha = alpha
        controller.leftAddressBar?.containerView.alpha = alpha
        
        let rightAddressBarIndex = controller.currentTabIndex + 1
        if !controller.hasHiddenTab || rightAddressBarIndex < controller.tabViewControllers.count - 1 {
            controller.rightAddressBar?.containerView.alpha = alpha
        }
    }
}
