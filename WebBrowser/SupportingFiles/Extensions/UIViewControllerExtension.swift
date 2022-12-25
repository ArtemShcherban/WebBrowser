//
//  UIViewControllerExtension.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 24.12.2022.
//

import UIKit

extension UIViewController {
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
