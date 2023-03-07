//
//  TabViewController+FavoritesViewDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 14.02.2023.
//

import UIKit

extension TabViewController: FavoritesViewDelegate {
    func hideKeyboard() {
        controller?.hideKeyboard()
    }
    
    @objc func hideFavoritesViewIfNedded() {
        guard hasLoadedURl else { return }
        tabView.hideFavoritesView()
    }
    
    func deleteSelectedCells() {
        guard let indexPaths = favoritesView.collectionView.indexPathsForSelectedItems else { return }
        favoritesModel.deleteBookmark(at: indexPaths)
        favoritesView.collectionViewDeleteCells(at: indexPaths)
    }
}
