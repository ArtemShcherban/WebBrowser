//
//  CDBookmarksCollection+CoreDataProperties.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 28.12.2022.
//
//

import Foundation
import CoreData

extension CDBookmarksCollection {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CDBookmarksCollection> {
        return NSFetchRequest<CDBookmarksCollection>(entityName: "CDBookmarksCollection")
    }

    @NSManaged public var bookmarks: NSOrderedSet
}

// MARK: Generated accessors for bookmarks
extension CDBookmarksCollection {
    @objc(insertObject:inBookmarksAtIndex:)
    @NSManaged public func insertIntoBookmark(_ value: CDBookmark, at idx: Int)

    @objc(removeObjectFromBookmarksAtIndex:)
    @NSManaged public func removeFromBookmarks(at idx: Int)

    @objc(insertBookmarks:atIndexes:)
    @NSManaged public func insertIntoBookmarks(_ values: [CDBookmark], at indexes: NSIndexSet)

    @objc(removeBookmarksAtIndexes:)
    @NSManaged public func removeFromBookmarks(at indexes: NSIndexSet)

    @objc(replaceObjectInBookmarksAtIndex:withObject:)
    @NSManaged public func replaceBookmarks(at idx: Int, with value: CDBookmark)

    @objc(replaceBookmarksAtIndexes:withBookmarks:)
    @NSManaged public func replaceBookmarks(at indexes: NSIndexSet, with values: [CDBookmark])

    @objc(addBookmarksObject:)
    @NSManaged public func addToBookmarks(_ value: CDBookmark)

    @objc(removeBookmarksObject:)
    @NSManaged public func removeBookmarks(_ value: CDBookmark)

    @objc(addBookmarks:)
    @NSManaged public func addToBookmarks(_ values: [NSOrderedSet])

    @objc(removeBookmarks:)
    @NSManaged public func removeFromBookmarks(_ values: NSOrderedSet)
}

extension CDBookmarksCollection: Identifiable {
}
