//
//  PortraitTabController+BookmarksCollectionViewDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 29.12.2022.
//

import UIKit

extension PortraitTabController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.cellForItem(at: indexPath) as? EditingBookmarkCell != nil {
            favoritesView.updateTrashButton()
        } else {
            let bookmark = favoritesModel.bookmarks[indexPath.row]
            controller?.bookmarkWasSelected(self, selected: bookmark)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard collectionView.cellForItem(at: indexPath) as? EditingBookmarkCell != nil
        else { return }
        favoritesView.updateTrashButton()
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        moveCellAt(sourceIndexPath, to: destinationIndexPath)
    }
}
