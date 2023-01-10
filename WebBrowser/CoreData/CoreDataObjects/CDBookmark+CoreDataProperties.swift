//
//  CDBookmark+CoreDataProperties.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 25.12.2022.
//
//

import Foundation
import CoreData

extension CDBookmark {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<CDBookmark> {
        return NSFetchRequest<CDBookmark>(entityName: "CDBookmark")
    }

    @NSManaged public var url: URL
    @NSManaged public var date: Date
    @NSManaged public var icon: Data?
    @NSManaged public var title: String
    @NSManaged public var collection: CDBookmarksCollection?
}

extension CDBookmark: Identifiable {
}
