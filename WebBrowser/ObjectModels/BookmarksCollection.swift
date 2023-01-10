//
//  BookmarksCollection.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 25.12.2022.
//

import Foundation

struct BookmarksCollection {
    var bookmarks: [Bookmark]
    
    init(bookmarks: [Bookmark]) {
        self.bookmarks = bookmarks
    }
}
