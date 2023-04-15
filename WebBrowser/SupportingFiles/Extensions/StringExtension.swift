//
//  StringExtension.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 23.03.2023.
//

import UIKit

extension String {
    func convertFirstCharacterToImage(with size: CGSize) -> UIImage? {
        guard let firstCharacter = self.first else { return nil }
        let firstCharacterString = String(firstCharacter).uppercased()
        
        let frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        let firstCharacterLabel = UILabel(frame: frame)
        let backgroundColor = UIColor.randomColor
        
        firstCharacterLabel.backgroundColor = backgroundColor
        firstCharacterLabel.textColor = backgroundColor.isDark ? .white : .darkGray
        firstCharacterLabel.font = UIFont.systemFont(ofSize: size.width / 1.6, weight: .light)
        firstCharacterLabel.text = firstCharacterString
        firstCharacterLabel.textAlignment = .center
        
        UIGraphicsBeginImageContext(frame.size)
        if let context = UIGraphicsGetCurrentContext() {
            firstCharacterLabel.layer.render(in: context)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            return image
        }
        return nil
    }
}
