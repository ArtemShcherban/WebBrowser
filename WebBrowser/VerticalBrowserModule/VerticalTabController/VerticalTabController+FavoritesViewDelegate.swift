//
//  VerticalTabController+FavoritesViewDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 14.02.2023.
//

import UIKit

extension VerticalTabController {
    override func hideFavoritesViewIfNedded() {
        super.hideFavoritesViewIfNedded()
        updateStatusBarColor()
    }
}
