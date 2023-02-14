//
//  BookmarkPresentTransition.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.02.2023.
//

import UIKit

class BookmarkPresentTransition: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.75
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        print("Transition")
        let toView = transitionContext.view(forKey: .to)
        
        guard let toView else { return }
        toView.transform = CGAffineTransform(scaleX: 1.33, y: 1.33)
          .concatenating(CGAffineTransform(translationX: 0.0, y: 200))
        toView.alpha = 0
        transitionContext.containerView.addSubview(toView)
        
        UIView.animate(withDuration: 0.75) {
            toView.transform = CGAffineTransform(translationX: 0, y: 100)
        }
        toView.transform = CGAffineTransform(translationX: 0, y: 60)
        toView.alpha = 1
        
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
}
