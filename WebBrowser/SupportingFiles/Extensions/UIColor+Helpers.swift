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
    
    static let tabCellLightGray = UIColor(
        red: 247 / 255,
        green: 248 / 255,
        blue: 247 / 255,
        alpha: 1
    )
    
    static let tabTitleDarkGray = UIColor(
        red: 126 / 255,
        green: 127 / 255,
        blue: 130 / 255,
        alpha: 1
    )
    
    static var randomColor: UIColor {
        let red = CGFloat(Int.random(in: 0...255)) / 255
        let green = CGFloat(Int.random(in: 0...255)) / 255
        let blue = CGFloat(Int.random(in: 0...255)) / 255
        
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
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
