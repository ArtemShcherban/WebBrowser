////
////  BookmarksViewController.swift
////  WebBrowser
////
////  Created by Artem Shcherban on 07.02.2023.
////
//
//import UIKit
//
//protocol BookmarksViewControllerDelegate: AnyObject {
//  func bookmarkWasSelected(_ boookmark: Bookmark)
//}
//
//class BookmarksViewController: UIViewController {
//
// 
//    var bookmarkModel = BookmarkModel()
//    var collectionView = BookmarksCollectionView()
////    var collectionView = UITableView()
//    
//    
//    weak var favoritesView: FavoritesView?
//    weak var delegate: BookmarksViewControllerDelegate?
//  
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .green
//
//        view.addSubview(collectionView)
//        collectionView.backgroundColor = .yellow
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        let aaaa = self.view.safeAreaInsets.bottom
//        
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -55)
//        ])
//        
//      
//        collectionView.delegate = self
//        collectionView.isScrollEnabled = true
//    }
//    
//    
//}
//
//extension BookmarksViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        100
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.textLabel?.text = "\(indexPath)"
//        return cell
//    }
//}
//
//extension BookmarksViewController: UICollectionViewDataSource {
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        1
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        bookmarkModel.bookmarks.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let collectionView = collectionView as? BookmarksCollectionView else {
//            return UICollectionViewCell()
//        }
//        if collectionView.isEditingMode {
//            return createEditingBookmarkCell(for: collectionView, at: indexPath)
//        } else {
//            let cell = createBookmarkCell(for: collectionView, at: indexPath)
//            return cell
//        }
//    }
//    
//    func collectionView(
//        _ collectionView: UICollectionView,
//        viewForSupplementaryElementOfKind kind: String,
//        at indexPath: IndexPath
//    ) -> UICollectionReusableView {
//        guard let headerView = collectionView.dequeueReusableSupplementaryView(
//            ofKind: UICollectionView.elementKindSectionHeader,
//            withReuseIdentifier: BookmarksHeaderView.reuseidentifier,
//            for: indexPath) as? BookmarksHeaderView else { return UICollectionReusableView() }
//        
//        return headerView
//    }
//    
//    private func createEditingBookmarkCell(
//        for collectionView: UICollectionView, at indexPath: IndexPath
//    ) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: EditingBookmarkCell.editingCollectionViewCellReuseID,
//            for: indexPath) as? EditingBookmarkCell else {
//            return UICollectionViewCell()
//        }
//        cell.configure(with: bookmarkModel.bookmarks[indexPath.row])
//        return cell
//    }
//    
//    private func createBookmarkCell(
//        for collectionView: UICollectionView, at indexPath: IndexPath
//    ) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: BookmarkCell.collectionViewCellReuseID,
//            for: indexPath) as? BookmarkCell else {
//            return UICollectionViewCell()
//        }
//        let bookmark = bookmarkModel.bookmarks[indexPath.row]
//        cell.configure(with: bookmark)
//        return cell
//    }
//}
//
//extension BookmarksViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if collectionView.cellForItem(at: indexPath) as? EditingBookmarkCell != nil {
//            favoritesView?.updateTrashButton()
//        } else {
//            let bookmark = bookmarkModel.bookmarks[indexPath.row]
//            delegate?.bookmarkWasSelected(bookmark)
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
//        guard collectionView.cellForItem(at: indexPath) as? EditingBookmarkCell != nil
//        else { return }
//        favoritesView?.updateTrashButton()
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        bookmarkModel.replaceBookmarksAt(sourceIndexPath, withAt: destinationIndexPath)
//    }
//}
