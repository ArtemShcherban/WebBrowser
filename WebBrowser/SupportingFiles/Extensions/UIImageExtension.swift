//
//  UIImageExtension.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 21.03.2023.
//

import UIKit

extension UIImage {
    func changeSizeTo(width: Double, height: Double) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), false, 0.0)
        self.draw(
            in: CGRect(
                x: 0,
                y: 0,
                width: width,
                height: height
            )
        )
        
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
