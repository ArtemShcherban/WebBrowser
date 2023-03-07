//
//  NotificationNameExtension.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 30.01.2023.
//

import Foundation

extension Notification.Name {
    static var backForwardStackHasChanged: Notification.Name {
        return .init(rawValue: "BackForwardStackHasChanged")
    }
    
    static var bookmarksRepositoryHasChanged: NSNotification.Name {
        return .init(rawValue: "BookmarksRepositoryHasChanged")
    }
    
    static var bookmarksCollectionHasChanged: Notification.Name {
        return .init(rawValue: "BookmarksCollectionHasChanged")
    }
}
