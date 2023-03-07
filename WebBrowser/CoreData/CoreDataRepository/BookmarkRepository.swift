//
//  BookmarkRepository.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 25.12.2022.
//

import Foundation
import CoreData

final class BookmarkRepository {
    let coreDataStack: CoreDataStack
    
    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    func save(bookmark: Bookmark) {
        let fetchRequest: NSFetchRequest = CDBookmarksCollection.fetchRequest()
        coreDataStack.backgroundContext.performAndWait {
            var cdCollection: CDBookmarksCollection
            if let collection = try? coreDataStack.backgroundContext.fetch(fetchRequest).first {
                cdCollection = collection
            } else {
                cdCollection = CDBookmarksCollection(context: coreDataStack.backgroundContext)
            }
            
            let cdBookmark = CDBookmark(context: coreDataStack.backgroundContext)
            cdBookmark.collection = cdCollection
            cdBookmark.title = bookmark.title
            cdBookmark.url = bookmark.url
            cdBookmark.date = bookmark.date
            let iconData = bookmark.icon?.pngData()
            cdBookmark.icon = iconData
        }
        coreDataStack.sychronizeConext()
    }
    
    func deleteCDBookmark(at indexes: [Int]) {
        let fetchRequest: NSFetchRequest = CDBookmarksCollection.fetchRequest()
        coreDataStack.backgroundContext.performAndWait {
            guard
                let cdCollection = try? coreDataStack.backgroundContext.fetch(fetchRequest).first
            else { return }
            
            indexes.forEach { index in
                guard let cdBookmark = cdCollection.bookmarks[index] as? CDBookmark
                else { return }
                coreDataStack.backgroundContext.delete(cdBookmark)
            }
        }
        coreDataStack.sychronizeConext()
    }
    
    func replaceCDBookmark(at sourceIndex: Int, to destinationIndex: Int) {
        let fetchRequest: NSFetchRequest = CDBookmarksCollection.fetchRequest()
        coreDataStack.backgroundContext.performAndWait {
            guard
                let cdCollection = try? coreDataStack.backgroundContext.fetch(fetchRequest).first,
                let cdBookmark = cdCollection.bookmarks[sourceIndex] as? CDBookmark
            else { return }
            
            cdCollection.removeFromBookmarks(at: sourceIndex)
            cdCollection.insertIntoBookmark(cdBookmark, at: destinationIndex)
        }
        coreDataStack.sychronizeConext()
    }
    
    func getBookmarks() -> [Bookmark] {
        let fetchRequest: NSFetchRequest = CDBookmarksCollection.fetchRequest()
        var bookmarks: [Bookmark] = []
        
        if let cdCollection = try? coreDataStack.managedObjectContext.fetch(fetchRequest).first {
            guard let cdBookmarks = cdCollection.bookmarks.array as? [CDBookmark] else {
                return []
            }
            bookmarks = cdBookmarks.map { $0.convertToBookmark() }
        }
        return bookmarks
    }
    
    func updateBookmarkWith(
        _ iconPNGData: Data,
        and url: URL
    ) {
        let fetchRequest: NSFetchRequest = CDBookmark.fetchRequest()
        let predicate = NSPredicate(format: "%K == %@", #keyPath(CDBookmark.url), url as NSURL)
        fetchRequest.predicate = predicate
        
        coreDataStack.backgroundContext.performAndWait {
            guard let cdBookmarks = try? coreDataStack.backgroundContext.fetch(fetchRequest) else {
                return
            }
            cdBookmarks.forEach { $0.icon = iconPNGData }
        }
        coreDataStack.sychronizeConext()
    }
}
