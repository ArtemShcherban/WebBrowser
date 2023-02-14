//
//  TabViewController+CollectionViewDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 14.02.2023.
//

import UIKit

extension TabViewController: UICollectionViewDelegate {
@objc func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookMark = favoritesModel.bookmarks[indexPath.row]
        controller?.bookmarkWasSelected(self, selected: bookMark)
    }
}
