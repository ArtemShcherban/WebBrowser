//
//  FavoritesModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 28.12.2022.
//

import UIKit
import WebKit

//protocol FavotitesModelDelegate: AnyObject {
////    func bookmarksChanged(_: [Bookmark])
//}

final class FavoritesModel {
    private var webView: WKWebView
    private let networkService: NetworkService
    private let bookmarkRepository: BookmarkRepository
    lazy var bookmarks: [Bookmark] = [] //{
   //     didSet {
//            delegate?.bookmarksChanged(bookmarks)
 //       }
  //  }
    
//    weak var delegate: FavotitesModelDelegate?
    
    init(
        webView: WKWebView,
//        delegate: FavotitesModelDelegate?,
        networkService: NetworkService = NetworkService(),
        bookmarkRepository: BookmarkRepository =
        BookmarkRepository(coreDataStack: CoreDataStack.shared)
    ) {
        self.webView = webView
//        self.delegate = delegate
        self.networkService = networkService
        self.bookmarkRepository = bookmarkRepository
    }
    
    func saveBookmark(with domain: String) {
        guard let bookmark = createBookmark(with: domain) else { return }
        bookmarkRepository.save(bookmark: bookmark)
        updateBookmarks()
    }
    
    func deletebookmark(at indexPaths: [IndexPath]) {
        let sortedIndexPaths = indexPaths.sorted {
            $0 > $1
        }
        sortedIndexPaths.forEach { bookmarks.remove(at: $0.row) }
        bookmarkRepository.deleteCDBookmark(at: sortedIndexPaths.map { $0.row })
    }
    
    
    
    func updateBookmarks() {
        bookmarks = bookmarkRepository.getBookmarks()
    }
    
    func replaceBookmarksAt(
        _ sourceIndexPath: IndexPath,
        withAt destinationIndexPath: IndexPath
    ) {
        let bookmark = bookmarks.remove(at: sourceIndexPath.row)
        bookmarks.insert(bookmark, at: destinationIndexPath.row)
        bookmarkRepository.replaceCDBookmark(
            at: sourceIndexPath.row,
            to: destinationIndexPath.row
        )
    }
}

private extension FavoritesModel {
    func createBookmark(with domain: String) -> Bookmark? {
        guard let url = webView.url else {
            print("Could not create Bookmark")
            return nil
        }
        let title = webView.title ?? String()
        
        let bookmark = Bookmark(
            title: title,
            url: url,
            date: Date(),
            icon: imageFromTitle(title: title)
        )
        
        getFavoriteIconImage(for: domain, and: url)
        
        return bookmark
    }
    
    func getFavoriteIconImage(for domain: String, and url: URL) {
        var iconImage: UIImage?
        networkService.loadIconData(for: domain) { result in
            switch result {
            case .success(let data):
                guard let tempIconImage = UIImage(data: data) else { return }
                if tempIconImage.size.width > 64 {
                    iconImage = self.reduceFavoriteIconSize(tempIconImage: tempIconImage)
                } else {
                    iconImage = tempIconImage
                }
            case .failure(let error):
                print(error.rawValue)
            }
            guard
                let iconImage,
                let iconPNGData = iconImage.pngData() else { return }
            self.bookmarkRepository.updateBookmarkWith(iconPNGData, and: url) {
                self.updateBookmarks()
            }
        }
    }
    
    func reduceFavoriteIconSize(tempIconImage: UIImage) -> UIImage? {
        let newIconSize = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContextWithOptions(newIconSize, false, 0.0)
        tempIconImage.draw(in: CGRect(
            x: 0,
            y: 0,
            width: newIconSize.width,
            height: newIconSize.height)
        )
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func imageFromTitle(title: String) -> UIImage? {
        guard let firstCharacter = title.first else { return nil }
        let firstCharacterString = String(firstCharacter).uppercased()
        
        let frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        let firstCharacterLabel = UILabel(frame: frame)
        let red = CGFloat(Int.random(in: 0...255)) / 255
        let green = CGFloat(Int.random(in: 0...255)) / 255
        let blue = CGFloat(Int.random(in: 0...255)) / 255
        var backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        firstCharacterLabel.backgroundColor = backgroundColor
        firstCharacterLabel.textColor = backgroundColor.isDark ? .white : .darkGray
        firstCharacterLabel.font = UIFont.systemFont(ofSize: 40, weight: .light)
        firstCharacterLabel.text = firstCharacterString
        firstCharacterLabel.textAlignment = .center
        
        UIGraphicsBeginImageContext(frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            firstCharacterLabel.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}
