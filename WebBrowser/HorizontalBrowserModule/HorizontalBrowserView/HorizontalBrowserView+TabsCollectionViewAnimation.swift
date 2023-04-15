//
//  HorizontalBrowserView+TabsCollectionViewAnimation.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 08.03.2023.
//

import UIKit

extension HorizontalBrowserView {
    func animateTabsCollectionViewAppearing() {
        UIView.animate(withDuration: 0.2) {
            self.tabsCollectionViewHeightConstraint?.constant = 30
            self.layoutIfNeeded()
        }
    }
    
    func animateTabsCollectionViewDisappearing() {
        let animator = AnimatorFactory.animator(
            for: self,
            duration: 0.2,
            animation: {
                self.tabsCollectionViewHeightConstraint?.constant = 5
            },
            completion: nil)
        animator.addAnimations(finalAnimation)
        animator.startAnimation()
    }
    
    private func finalAnimation() {
        tabsCollectionViewHeightConstraint?.constant = 0
    }
}
