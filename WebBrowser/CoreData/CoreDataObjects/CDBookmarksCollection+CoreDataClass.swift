//
//  CDBookmarksCollection+CoreDataClass.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 28.12.2022.
//
//

import Foundation
import CoreData

public class CDBookmarksCollection: NSManagedObject {
    func convertToBookmarksCollection() -> BookmarksCollection {
        guard let cdBookmarks = self.bookmarks.array as? [CDBookmark] else {
            return BookmarksCollection(bookmarks: [])
        }
        let bookmarks = cdBookmarks.map { cdBookmark in
            cdBookmark.convertToBookmark()
        }
        let bookmarksCollection = BookmarksCollection(bookmarks: bookmarks)
        return bookmarksCollection
    }
}
