//
//  HorizontalBrowserController+AddressBarDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 21.03.2023.
//

import UIKit

extension HorizontalBrowserController {
    override func addressBar(_ addressBar: AddressBar, didReturnWithText text: String) {
        if
            let url = browserModel.getURL(for: text),
            currentTabController.hasURLHostChanged(in: url) {
            tabsCollectionViewModel.getFavoriteIcon(for: currentTabIndex, andFor: url)
        }
        super.addressBar(addressBar, didReturnWithText: text)
    }
}
