//
//  Array+Helpers.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import Foundation

extension Array {
    subscript (safe index: Int) -> Iterator.Element? {
        get {
            (startIndex <= index && index < endIndex) ? self[index] : nil
        }
        set {
            guard
                startIndex <= index && index < endIndex,
                let newValue = newValue else { return }
            self[index] = newValue
        }
    }
}
