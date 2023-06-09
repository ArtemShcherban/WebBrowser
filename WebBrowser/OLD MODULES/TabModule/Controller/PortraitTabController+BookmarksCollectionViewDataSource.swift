//
//  PortraitTabController+BookmarksCollectionViewDataSource.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 29.12.2022.
//

import UIKit

extension PortraitTabController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
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
        return cell
    }
}
