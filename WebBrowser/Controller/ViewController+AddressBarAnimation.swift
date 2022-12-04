//
//  ViewController+AddressBarAnimation.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

extension ViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        currentTabIndex = Int(
            round(webBrowserView.addressBarScrollView.contentOffset.x / webBrowserView.addressBarPageWidth)
        )
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if currentTabIndex == 0 && hasHiddenTab {
            let currentXOffset = webBrowserView.addressBarScrollView.contentOffset.x
            let addressBarWidth = webBrowserView.frame.width + webBrowserView.addressBarWidthOffset
            let hiddenAddressBarWidth = addressBarWidth + webBrowserView.addressBarContainerHidingWidthOffset
            let offsetBeforeStartingStretching =
            CGFloat(currentTabIndex) * webBrowserView.addressBarPageWidth + hiddenAddressBarWidth
            
            let percentage = 1 - (offsetBeforeStartingStretching - currentXOffset) / hiddenAddressBarWidth
            guard let hiddenAddressBar = webBrowserView.addressBars.last else { return }
            hiddenAddressBar.containerView.alpha = min(1, percentage * 1.2)
            
            if currentXOffset > offsetBeforeStartingStretching {
                let diff = currentXOffset - offsetBeforeStartingStretching
                hiddenAddressBar.containerViewWidthConstraint?.constant =
                diff + webBrowserView.addressBarContainerHidingWidthOffset
            }
        }
        
        if currentTabIndex == 1 && hasHiddenTab {
            let currentXOffset = webBrowserView.addressBarScrollView.contentOffset.x
            let addressBarWidth = webBrowserView.frame.width + webBrowserView.addressBarWidthOffset
            let hiddenAddressBarWidth = addressBarWidth + webBrowserView.addressBarContainerHidingWidthOffset
            let offsetBeforeStartingStretching =
            CGFloat(currentTabIndex - 1) * webBrowserView.addressBarPageWidth + hiddenAddressBarWidth
            let diff = currentXOffset - offsetBeforeStartingStretching
            guard let hiddenAddressBar = webBrowserView.addressBars.last else { return }
            let widthOffset = webBrowserView.addressBarContainerHidingWidthOffset + diff
            hiddenAddressBar.containerViewWidthConstraint?.constant = widthOffset < 0 ? widthOffset : 0
        }
    }
    
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        let pageFraction = targetContentOffset.pointee.x / webBrowserView.addressBarPageWidth
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
            x: CGFloat(currentTabIndex) * webBrowserView.addressBarPageWidth,
            y: targetContentOffset.pointee.y
        )
        
        if currentTabIndex == 1 && hasHiddenTab {
            let hiddenAddressBar = webBrowserView.addressBars.last
            UIView.animate(withDuration: 0.3) {
                hiddenAddressBar?.containerView.alpha = 1
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if currentTabIndex == 1 {
            hasHiddenTab = false
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && currentTabIndex == 1 {
            hasHiddenTab = false
        }
    }
}
