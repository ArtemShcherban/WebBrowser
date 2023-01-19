//
//  AddressBar+Animation.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 14.01.2023.
//

import UIKit

extension AddressBar {
    func animateDomainLabelExtension(with notification: NSNotification, view: UIView) {
        // In some cases keyboard willShow is called multiple times.
        // We have to create an animator only if the domainLabel on the screen
        guard domainLabel == containerView.subviews.last else { return }
        
        let animator = AnimatorFactory.domainLabelAnimator(
            for: notification,
            view: view,
            animation: domainLabelAnimationOnActivation(),
            completion: ({ position in
                self.textField.activityState = .editing
                self.bringTextFieldToFront(position: position)()
            })
        )
        
        animator?.addAnimations {
            UIView.animate(withDuration: 0.0) {
                self.textField.aAButton?.alpha = 0
                self.textField.reloadButton.alpha = 0
            }
        }
        
        animator?.startAnimation()
    }
    
    func animateDomainLabelCollapsing(with notification: NSNotification, view: UIView) {
        let animator = AnimatorFactory.domainLabelAnimator(
            for: notification,
            view: view,
            animation: domainLabelAnimationOnDeactivating()
        )
        
        animator?.addAnimations({
            self.textField.aAButton?.alpha = 1
            self.textField.reloadButton.alpha = 1
        }, delayFactor: 0.3)
        
        animator?.startAnimation()
    }
    
    func animateDomainLabelFirstAppearing() {
        UIView.animate(withDuration: 0.5) {
            self.domainLabel.alpha = 1
            UIView.animate(withDuration: 0, delay: 0.2) {
                self.textField.aAButton?.alpha = 1
                self.textField.reloadButton.alpha = 1
            }
        }
    }
    
    private func domainLabelAnimationOnActivation() -> (() -> Void) {
        return {
            self.toURLStringTransitionAnimation()
            self.domainLabelCenterXConstraint?.isActive = false
            self.domainLabelMaxLeadingConstraint?.constant = 15
            self.domainLabelMinLeadingConstraint?.constant = 15
            self.domainLabelTrailingConstraint?.isActive = true
            self.textFieldLeadingConstraint?.constant = 0
            self.textFieldTrailingConstraint?.constant = 0
            self.shadowView.alpha = 0
        }
    }
    
    private func domainLabelAnimationOnDeactivating() -> (() -> Void) {
        return {
            self.toDomainTitleStringTransitionAnimation()
          
            self.domainLabelTrailingConstraint?.isActive = false
            self.domainLabelCenterXConstraint?.isActive = true
            self.domainLabelMaxLeadingConstraint?.constant = 300
            self.domainLabelMinLeadingConstraint?.constant = 40
            self.textFieldLeadingConstraint?.constant = self.textFieldPadding
            self.textFieldTrailingConstraint?.constant = -self.textFieldPadding
            self.textField.textColor = .clear
            self.shadowView.alpha = 1
        }
    }
    
    private func toURLStringTransitionAnimation() {
        UIView.transition(
            with: domainLabel,
            duration: 0.0,
            options: .transitionCrossDissolve
        ) {
            self.domainLabel.text = self.textField.text
        }
    }
    
    private func toDomainTitleStringTransitionAnimation() {
        UIView.transition(
            with: domainLabel,
            duration: 0.0,
            options: .transitionCrossDissolve
        ) {
            self.domainLabel.text = self.domainTitleString
        }
    }
    
    private func bringTextFieldToFront(position: UIViewAnimatingPosition) -> (() -> Void) {
        return {
            switch position {
            case .end:
                self.textField.textColor = .black
                self.containerView.bringSubviewToFront(self.textField)
                self.textField.selectedTextRange = self.textField.textRange(
                    from: self.textField.beginningOfDocument,
                    to: self.textField.endOfDocument)
            default:
                break
            }
        }
    }
}
