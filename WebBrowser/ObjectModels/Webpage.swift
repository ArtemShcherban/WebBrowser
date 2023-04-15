//
//  Webpage.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 30.01.2023.
//

import Foundation
import WebKit

struct Webpage: Equatable {
    var url: URL?
    var title: String?
    var favoriteIcon: UIImage?
    var error: NSError?
    var contentMode: WKWebpagePreferences.ContentMode
}
