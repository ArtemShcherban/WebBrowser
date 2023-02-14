//
//  DataSource.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.02.2023.
//

import UIKit

class DataSource: NSObject, UICollectionViewDataSource {
    private var favoritesModel: FavoritesModel
    
    init(favoritesModel: FavoritesModel) {
        self.favoritesModel = favoritesModel
    }
    
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
            return createEditingBookmarkCell(for: collectionView, at: indexPath)
        } else {
            let cell = createBookmarkCell(for: collectionView, at: indexPath)
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
    
    private func createEditingBookmarkCell(
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
    
    private func createBookmarkCell(
        for collectionView: UICollectionView, at indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: BookmarkCell.collectionViewCellReuseID,
            for: indexPath) as? BookmarkCell else {
            return UICollectionViewCell()
        }
        let bookmark = favoritesModel.bookmarks[indexPath.row]
        cell.configure(with: bookmark)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        favoritesModel.replaceBookmarksAt(sourceIndexPath, withAt: destinationIndexPath)
    }
}
