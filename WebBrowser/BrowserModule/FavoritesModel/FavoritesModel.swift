//
//  FavoritesModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 28.12.2022.
//

import UIKit

final class FavoritesModel {
    private let networkService: NetworkService
    private let bookmarkRepository: BookmarkRepository
    
    init(
        networkService: NetworkService = NetworkService(),
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
        guard let host = url.host else { return }
        var iconImage: UIImage?
        networkService.loadIconData(for: host) { result in
            switch result {
            case .success(let data):
                guard let tempIconImage = UIImage(data: data) else { return }
                if tempIconImage.size.width > 64 {
                    iconImage = tempIconImage.changeSizeTo(width: 50, height: 50)
                } else if tempIconImage.size.width >= 32 {
                    iconImage = tempIconImage
                }
            case .failure(let error):
                print(error.rawValue)
            }
            guard
                let iconImage,
                let iconPNGData = iconImage.pngData() else { return }
            self.bookmarkRepository.updateBookmarkWith(iconPNGData, and: url)
        }
    }
}
