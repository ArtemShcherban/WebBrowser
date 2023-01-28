//
//  NotificationNameExtension.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 30.01.2023.
//

import Foundation

extension Notification.Name {
    static var backForwardStackChanged: Notification.Name {
        return .init(rawValue: "BackForwardStackChanged")
    }
}
