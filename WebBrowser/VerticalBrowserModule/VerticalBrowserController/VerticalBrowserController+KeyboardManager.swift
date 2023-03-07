//
//  VerticalBrowserController+KeyboardManager.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 15.02.2023.
//

import UIKit

extension VerticalBrowserController {
    override func updateAddressBarStateForKeyboardAppearing(with notification: NSNotification) {
        updateFavoritesViewWithCancellButton(hidden: false)
        super.updateAddressBarStateForKeyboardAppearing(with: notification)
        verticalBrowserView.animateAddressBarMovingUpwards(with: notification, and: self.view)
        setSideAddressBarsHidden(true)
    }
    
    override func updateAddressBarStateForKeyboardDisappearing(with notification: NSNotification) {
        updateFavoritesViewWithCancellButton(hidden: true)
        super.updateAddressBarStateForKeyboardDisappearing(with: notification)
        verticalBrowserView.animateAddressBarMovingDownwards(with: notification, view: self.view)
        setSideAddressBarsHidden(false)
    }
    
    private func updateFavoritesViewWithCancellButton(hidden: Bool) {
        guard let currentTabController = currentTabController as? VerticalTabController
        else { return }
        currentTabController.finishEditingModeIfNeeded()
        currentTabController.cancelButton(isHidden: hidden)
    }
    
    private func setSideAddressBarsHidden(_ isHidden: Bool) {
        if let leftAddressBar {
            setHidden(isHidden, forLeftAddressBar: leftAddressBar)
        }
        if let rightAddressBar {
            setHidden(isHidden, forRightAddressBar: rightAddressBar)
        }
    }
    
    private func setHidden(_ isHidden: Bool, forRightAddressBar addressBar: AddressBar) {
        // In some cases keyboard willShow is called multiple times.
        // To prevent the address bar center from being offset multiple times we have to check if it is already offset
        if isHidden && addressBar.alpha == 0 {
            return
        }
        
        let offset = verticalBrowserView.addressBarHiddingCenterOffset
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
    
    private func setHidden(_ isHidden: Bool, forLeftAddressBar addressBar: AddressBar) {
        if isHidden && addressBar.alpha == 0 {
            return
        }
        
        let offset = verticalBrowserView.addressBarHiddingCenterOffset
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
