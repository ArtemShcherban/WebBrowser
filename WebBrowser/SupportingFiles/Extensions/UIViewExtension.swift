//
//  UIViewExtension.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.01.2023.
//

import UIKit

extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        animation.type = .fade
        animation.duration = duration
        self.layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}
