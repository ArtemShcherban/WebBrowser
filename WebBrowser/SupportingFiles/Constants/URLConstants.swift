//
//  URLConstants.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 28.12.2022.
//

import Foundation

enum URLConstants {
    enum GoogleFavoriteIcon {
        static let scheme = "https"
        static let host = "www.google.com"
        static let path = "/s2/favicons"
        static let query = "domain"
        static let iconSize = "sz"
        static let sixtyFour = "64"
    }
    
    enum IconHorseFavoriteIcon {
        static let scheme = "https"
        static let host = "icon.horse"
        static let path = "/icon/"
    }
}
