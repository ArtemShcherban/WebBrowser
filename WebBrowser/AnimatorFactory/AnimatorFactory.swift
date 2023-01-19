//
//  AnimatorFactory.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 14.01.2023.
//

import UIKit

enum AnimatorFactory {
    static func animateWithKeyboard(
        for notification: NSNotification,
        view: UIView,
        animation: ((CGRect) -> Void)?,
        completion: (() -> Void)? = nil
    ) -> UIViewPropertyAnimator? {
        guard
            let duration = notification.keyboardAnimationDuration,
            let curve = notification.keyboardAnimationCurve,
            let frame = notification.keyboardEndFrame else { return nil }
        
        let propertyAnimator = UIViewPropertyAnimator(duration: duration, curve: curve)
        
        propertyAnimator.addAnimations {
            animation?(frame)
            view.layoutIfNeeded()
        }
        propertyAnimator.addCompletion { _ in
            completion?()
        }
        return propertyAnimator
    }
    
    static func domainLabelAnimator(
        for notification: NSNotification,
        view: UIView,
        animation: (() -> Void)?,
        completion: ((UIViewAnimatingPosition) -> Void)? = nil
    ) -> UIViewPropertyAnimator? {
        guard
            let duration = notification.keyboardAnimationDuration else { return  nil }
        
        let animator = UIViewPropertyAnimator(duration: duration, curve: .linear)
        
        animator.addAnimations {
            animation?()
            view.layoutIfNeeded()
        }
        
        animator.addCompletion { position in
            completion?(position)
        }
        
        return animator
    }
}
