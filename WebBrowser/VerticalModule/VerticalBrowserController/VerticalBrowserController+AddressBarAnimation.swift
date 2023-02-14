//
//  VerticalBrowserController+AddressBarAnimation.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 15.02.2023.
//

import UIKit

extension VerticalBrowserController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentTabIndex = Int(
            round(verticalBrowserView.addressBarScrollView.contentOffset.x / verticalBrowserView.addressBarPageWidth)
        )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let padding = 2 * (
            verticalBrowserView.addressBarStackViewSidePadding -
            verticalBrowserView.addressBarStackViewSpacing / 2
        )
        let percentage =
        verticalBrowserView.addressBarScrollView.contentOffset.x /
        (verticalBrowserView.addressBarScrollView.contentSize.width - padding)
        
        verticalBrowserView.tabScrollView.contentOffset.x =
        percentage *
        (verticalBrowserView.tabScrollView.contentSize.width + verticalBrowserView.tabStackSpacing)
        
        if currentTabIndex == tabViewControllers.count - 2 && hasHiddenTab {
            let currentXOffset = verticalBrowserView.addressBarScrollView.contentOffset.x
            let addressBarWidth = verticalBrowserView.frame.width + verticalBrowserView.addressBarWidthOffset
            let hiddenAddressBarWidth = addressBarWidth + verticalBrowserView.addressBarContainerHidingWidthOffset
            let offsetBeforeStartingStretching =
            CGFloat(currentTabIndex) * verticalBrowserView.addressBarPageWidth + hiddenAddressBarWidth
            
            let percentage = 1 - (offsetBeforeStartingStretching - currentXOffset) / hiddenAddressBarWidth
            guard let hiddenAddressBar = verticalBrowserView.addressBars.last else { return }
            hiddenAddressBar.containerView.alpha = min(1, percentage * 1.2)
            
            if currentXOffset > offsetBeforeStartingStretching {
                let diff = currentXOffset - offsetBeforeStartingStretching
                hiddenAddressBar.containerViewWidthConstraint?.constant =
                diff + verticalBrowserView.addressBarContainerHidingWidthOffset
            }
        }
        
        if currentTabIndex == tabViewControllers.count - 1 && hasHiddenTab {
            let currentXOffset = verticalBrowserView.addressBarScrollView.contentOffset.x
            let addressBarWidth = verticalBrowserView.frame.width + verticalBrowserView.addressBarWidthOffset
            let hiddenAddressBarWidth = addressBarWidth + verticalBrowserView.addressBarContainerHidingWidthOffset
            let offsetBeforeStartingStretching =
            CGFloat(currentTabIndex - 1) * verticalBrowserView.addressBarPageWidth + hiddenAddressBarWidth
            let diff = currentXOffset - offsetBeforeStartingStretching
            guard let hiddenAddressBar = verticalBrowserView.addressBars.last else { return }
            let widthOffset = verticalBrowserView.addressBarContainerHidingWidthOffset + diff
            hiddenAddressBar.containerViewWidthConstraint?.constant = widthOffset < 0 ? widthOffset : 0
        }
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let pageFraction = targetContentOffset.pointee.x / verticalBrowserView.addressBarPageWidth
        var nextTabIndex: Int
        
        if velocity.x > 0 {
            nextTabIndex = Int(ceil(pageFraction))
        } else if velocity.x == 0 {
            nextTabIndex = Int(round(pageFraction))
        } else {
            nextTabIndex = Int(floor(pageFraction))
        }
        
        if currentTabIndex < nextTabIndex {
            currentTabIndex += 1
        } else if currentTabIndex > nextTabIndex {
            currentTabIndex -= 1
        }
        
        targetContentOffset.pointee = CGPoint(
            x: CGFloat(currentTabIndex) * verticalBrowserView.addressBarPageWidth,
            y: targetContentOffset.pointee.y
        )
        
        if currentTabIndex == tabViewControllers.count - 1 && hasHiddenTab {
            let tabViewController = tabViewControllers.last
            let hiddenAddressBar = verticalBrowserView.addressBars.last
            UIView.animate(withDuration: 0.3) {
                tabViewController?.view.transform = .identity
                tabViewController?.view.alpha = 1
                hiddenAddressBar?.containerView.alpha = 1
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if currentTabIndex == tabViewControllers.count - 1 {
            hasHiddenTab = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && currentTabIndex == tabViewControllers.count - 1 {
            hasHiddenTab = false
        }
    }
}
