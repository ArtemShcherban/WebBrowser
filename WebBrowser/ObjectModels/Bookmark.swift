//
//  Bookmark.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 25.12.2022.
//

import UIKit

class Bookmark: NSObject {
    var title: String
    var url: URL
    var date: Date
    var icon: UIImage?
    
    init(title: String, url: URL, date: Date, icon: UIImage?) {
        self.title = title
        self.url = url
        self.date = date
        self.icon = icon
    }
}
