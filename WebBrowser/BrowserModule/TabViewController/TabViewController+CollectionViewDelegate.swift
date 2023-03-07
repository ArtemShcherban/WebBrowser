//
//  TabViewController+CollectionViewDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 14.02.2023.
//

import UIKit

extension TabViewController: UICollectionViewDelegate {
@objc func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard
        let cell = collectionView.cellForItem(at: indexPath) as? BookmarkCell,
        let bookmark = cell.bookmark else { return }
        controller?.bookmarkHasTapped(self, bookmark)
    }
}
