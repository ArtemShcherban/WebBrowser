//
//  UIMenuButton.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 22.12.2022.
//

import UIKit

protocol UIMenuButtonDelegate: AnyObject {
    func contextMenuWillShow()
    func contextMenuWillHide()
}

class UIMenuButton: UIButton {
    weak var delegate: UIMenuButtonDelegate?
    
    override func sendActions(for controlEvents: UIControl.Event) {
        super.sendActions(for: controlEvents)
        if
            #available(iOS 14.0, *),
            controlEvents.contains(.menuActionTriggered) {
            delegate?.contextMenuWillShow()
        }
    }
    
    override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        if #available(iOS 14.0, *) {
            super.contextMenuInteraction(interaction, willEndFor: configuration, animator: animator)
            delegate?.contextMenuWillHide()
        }
    }
}

extension UIMenu {
}
