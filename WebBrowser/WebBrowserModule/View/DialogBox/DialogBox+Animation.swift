//
//  DialogBox+Animation.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 16.01.2023.
//

import UIKit

extension DialogBox {
    func animateDialogBoxAppearing(with notification: NSNotification, view: UIView) {
        let animator = AnimatorFactory.animateWithKeyboard(
            for: notification,
            view: view
        ) { _ in
            self.updateDialogBoxStateForKeyboardAppearing()
        }
        animator?.startAnimation()
    }
    
    func animateDialogBoxDisappearing(
        with notification: NSNotification,
        view: UIView,
        completion: @escaping(() -> Void)
    ) {
        let animator = AnimatorFactory.animateWithKeyboard(
            for: notification,
            view: view,
            animation: { _ in
                self.alpha = 0
            },
            completion: {
                completion()
            }
        )
        animator?.startAnimation()
    }
    
    private func updateDialogBoxStateForKeyboardAppearing() {
        alpha = 1
        dialogBoxViewBottomConstraints?.constant =
        Interface.orientation == .portrait ? -55 : -36
    }
}
