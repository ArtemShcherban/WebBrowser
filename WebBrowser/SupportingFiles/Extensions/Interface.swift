//
//  Interface.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.02.2023.
//

import UIKit

enum Interface {
    private static let scene = UIApplication.shared.connectedScenes.first
    
    enum Orientation {
        case portrait
        case landscape
    }
    
    static var orientation: Orientation {
        guard let scene = scene as? UIWindowScene else {
            return .portrait
        }
        if scene.traitCollection.horizontalSizeClass == .compact
            && scene.traitCollection.verticalSizeClass == .regular {
            return .portrait
        } else {
            return .landscape
        }
    }
    
    static var screenWidth: CGFloat {
        guard let scene = scene as? UIWindowScene else {
            return 0.0
        }
        return scene.screen.bounds.width
    }
    
    static var screenHeight: CGFloat {
        guard let scene = scene as? UIWindowScene else {
            return 0.0
        }
        return scene.screen.bounds.height
    }
}
