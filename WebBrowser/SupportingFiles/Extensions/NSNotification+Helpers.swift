//
//  NSNotification+Helpers.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

extension NSNotification {
    var keyboardEndFrame: CGRect? {
        return (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    }
    
    var keyboardAnimationDuration: Double? {
        userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
    }
    
    var keyboardAnimationCurve: UIView.AnimationCurve? {
        guard let curveValue = userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? Int else {
            return nil
        }
        return UIView.AnimationCurve(rawValue: curveValue)
    }
}
