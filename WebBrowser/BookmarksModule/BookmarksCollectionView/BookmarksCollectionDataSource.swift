//
//  BookmarksCollectionDataSource.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.02.2023.
//

import UIKit

final class BookmarksCollectionDataSource: NSObject, UICollectionViewDataSource {
    static let shared = BookmarksCollectionDataSource()
    private var favoritesModel = FavoritesModel()
    private var bookmarkRepository: BookmarkRepository
    private var bookmarks: [Bookmark] = []
    
    init(
        bookmarkRepository: BookmarkRepository = BookmarkRepository(coreDataStack: CoreDataStack.shared)
    ) {
        self.bookmarkRepository = bookmarkRepository
        super.init()
        updateBookmarks()
        startBookmarkRepositoryObserve()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bookmarks.count
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
        cell.configure(with: bookmarks[indexPath.row])
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
        let bookmark = bookmarks[indexPath.row]
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

private extension BookmarksCollectionDataSource {
    func startBookmarkRepositoryObserve() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(updateBookmarks),
                name: .bookmarksRepositoryHasChanged,
                object: nil
            )
    }
}
    
@objc private extension BookmarksCollectionDataSource {
    func updateBookmarks() {
        bookmarks = bookmarkRepository.getBookmarks()
        NotificationCenter.default.post(name: .bookmarksCollectionHasChanged, object: nil)
    }
}
