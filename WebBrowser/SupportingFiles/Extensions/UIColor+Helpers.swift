//
//  UIColor+Helpers.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

extension UIColor {
    static let placeholderGray = UIColor(
        white: 138 / 255,
        alpha: 1
    )
    
    static let textFieldGray = UIColor(
        red: 227 / 255,
        green: 228 / 255,
        blue: 227 / 255,
        alpha: 1
    )
    
    static let loadingBlue = UIColor(
        red: 0,
        green: 122 / 255,
        blue: 255 / 255,
        alpha: 1
    )
    
    static let keyboardGray = UIColor(
        red: 214 / 255,
        green: 215 / 255,
        blue: 220 / 255,
        alpha: 1
    )
}

extension UIColor {
    var isDark: Bool {
        var red, green, blue, alpha: CGFloat
        (red, green, blue, alpha) = (0, 0, 0, 0)
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        let luminance = 0.2126 * red + 0.7152 * green + 0.0722 * blue
        return luminance < 0.5
    }
}
