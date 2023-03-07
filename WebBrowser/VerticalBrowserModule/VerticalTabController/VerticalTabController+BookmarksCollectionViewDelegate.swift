//
//  VerticalTabController+BookmarksCollectionViewDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 15.02.2023.
//

import UIKit

extension VerticalTabController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) as? EditingBookmarkCell != nil {
            favoritesView.updateTrashButton()
        } else {
            super.collectionView(collectionView, didSelectItemAt: indexPath)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard collectionView.cellForItem(at: indexPath) as? EditingBookmarkCell != nil
        else { return }
        favoritesView.updateTrashButton()
    }
}
