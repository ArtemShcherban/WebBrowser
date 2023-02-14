//
//  TabViewController+FavoritesViewDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 14.02.2023.
//

import UIKit

extension TabViewController: FavoritesViewDelegate {
    func collectionViewDidScroll(_ sender: UIPanGestureRecognizer) {
        controller?.hideKeyboard()
    }
    
    func cancelButtonTapped() {
        guard let controller = controller as? VerticalBrowserController else { return }
        controller.hideKeyboard()
    }
    
    @objc func hideFavoritesViewIfNedded() {
        guard hasLoadedURl else { return }
        tabView.hideFavoritesView()
    }
    
    func trashButtonTapped() {
        guard let indexPaths = favoritesView.collectionView.indexPathsForSelectedItems else { return }
        favoritesModel.deletebookmark(at: indexPaths)
        favoritesView.collectionViewDeleteCells(at: indexPaths)
    }
}
