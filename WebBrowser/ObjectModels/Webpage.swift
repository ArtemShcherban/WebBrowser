//
//  Webpage.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 30.01.2023.
//

import Foundation
import WebKit
import RxSwift
import RxRelay

class Webpage: Equatable {
    static func == (lhs: Webpage, rhs: Webpage) -> Bool {
        lhs.url == rhs.url
    }
    
    var url: URL?
    var title: String?
    var mainTitle: BehaviorSubject<String?>
    var favoriteIcon: BehaviorSubject<UIImage?>
    var error: NSError?
    var contentMode: BehaviorRelay<WKWebpagePreferences.ContentMode>
    
    init(
        url: URL? = nil,
        title: String? = nil,
        mainTitle: String? = nil,
        favoriteIcon: UIImage? = nil,
        error: NSError? = nil,
        contentMode: WKWebpagePreferences.ContentMode
    ) {
        self.url = url
        self.title = title
        self.mainTitle = BehaviorSubject(value: mainTitle)
        self.favoriteIcon = BehaviorSubject(value: favoriteIcon)
        self.error = error
        self.contentMode = BehaviorRelay(value: contentMode)
    }
}
