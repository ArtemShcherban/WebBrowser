//
//  Headline.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 21.03.2023.
//

import UIKit
import RxSwift
import RxDataSources

struct Headline: IdentifiableType, Equatable {
    typealias Identity = UUID
   
    let uid = UUID()
    var title: String
    var favoriteIcon: UIImage
    var isActive: Bool
    var identity: UUID {
        uid
    }
}
