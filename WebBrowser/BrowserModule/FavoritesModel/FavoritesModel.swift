//
//  FavoritesModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 28.12.2022.
//

import UIKit
import RxSwift

final class FavoritesModel {
    private let networkService: IconNetworkService
    private let bookmarkRepository: BookmarkRepository
    
    init(
        networkService: IconNetworkService = IconNetworkService(),
        bookmarkRepository: BookmarkRepository =
        BookmarkRepository(coreDataStack: CoreDataStack.shared)
    ) {
        self.networkService = networkService
        self.bookmarkRepository = bookmarkRepository
    }
    
    func saveBookmark(with currentWebpage: Webpage) {
        guard let bookmark = createBookmark(with: currentWebpage) else { return }
        bookmarkRepository.save(bookmark: bookmark)
    }
    
    func deleteBookmark(at indexPaths: [IndexPath]) {
        let sortedIndexPaths = indexPaths.sorted {
            $0 > $1
        }
        bookmarkRepository.deleteCDBookmark(at: sortedIndexPaths.map { $0.row })
    }
    
    func replaceBookmarksAt(
        _ sourceIndexPath: IndexPath,
        withAt destinationIndexPath: IndexPath
    ) {
        bookmarkRepository.replaceCDBookmark(
            at: sourceIndexPath.row,
            to: destinationIndexPath.row
        )
    }
}

private extension FavoritesModel {
    func createBookmark(with currentWebpage: Webpage) -> Bookmark? {
        guard let url = currentWebpage.url else {
            return nil
        }
        let title = currentWebpage.title ?? String()
        
        let bookmark = Bookmark(
            title: title,
            url: url,
            date: Date(),
            icon: title.convertFirstCharacterToImage(with: CGSize(width: 64, height: 64))
        )
        
        getBookmarkFavoriteIconImage(for: url)
        
        return bookmark
    }
    
    func getBookmarkFavoriteIconImage(for url: URL) {
        var iconImage: UIImage?
        var subscription = Disposables.create()
        do {
            try networkService.loadIconData(with: url, forBookmark: true)
            subscription = networkService.favoriteIconRelay
                .subscribe { [weak self] tempIconImage in
                    guard let tempIconImage else { return }
                    if tempIconImage.size.width > 64 {
                        iconImage = tempIconImage.changeSizeTo(width: 50, height: 50)
                    } else if tempIconImage.size.width >= 32 {
                        iconImage = tempIconImage
                    }
                    guard
                        let iconImage,
                        let iconPNGData = iconImage.pngData() else { return }
                    self?.bookmarkRepository.updateBookmarkWith(iconPNGData, and: url)
                    subscription.dispose()
                }
        } catch let error {
            if let error = error as? NetworkServiceError {
                print(error.rawValue)
            }
        }
    }
}
