//
//  CDBookmark+CoreDataClass.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 25.12.2022.
//
//

import Foundation
import CoreData
import UIKit

@objc(CDBookmark)
public class CDBookmark: NSManagedObject {
    func convertToBookmark() -> Bookmark {
        var icon: UIImage?
        
        if
            let iconData = self.icon,
            let iconImage = UIImage(data: iconData) {
            print()
            icon = iconImage
        }
        let bookmark = Bookmark(
            title: self.title,
            url: self.url,
            date: self.date,
            icon: icon
        )
        return bookmark
    }
}
