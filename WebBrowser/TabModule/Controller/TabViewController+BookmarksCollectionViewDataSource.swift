//
//  TabViewController+BookmarksCollectionViewDataSource.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 29.12.2022.
//

import UIKit

extension TabViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        favoritesModel.bookmarks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let collectionView = collectionView as? BookmarksCollectionView else {
            return UICollectionViewCell()
        }
        if collectionView.isEditingMode {
            return createEditingCollectionViewCell(for: collectionView, at: indexPath)
        } else {
            let cell = createCollectionViewCell(for: collectionView, at: indexPath)
            return cell
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BookmarksHeaderView.reuseidentifier,
            for: indexPath) as? BookmarksHeaderView else { return UICollectionReusableView() }
        
        return headerView
    }
    
    private func createEditingCollectionViewCell(
        for collectionView: UICollectionView, at indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: EditingBookmarkCell.editingCollectionViewCellReuseID,
            for: indexPath) as? EditingBookmarkCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: favoritesModel.bookmarks[indexPath.row])
        return cell
    }
    
    private func createCollectionViewCell(
        for collectionView: UICollectionView, at indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookmarkCellCell.collectionViewCellReuseID,
            for: indexPath) as? BookmarkCellCell else {
            return UICollectionViewCell()
        }
        let bookmark = favoritesModel.bookmarks[indexPath.row]
        cell.configure(with: bookmark)
        return cell
    }
}
