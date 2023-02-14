//
//  AaButton.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 22.12.2022.
//

import UIKit
import WebKit

protocol AaButtonDelegate: AnyObject {
    func contextMenuWillShow()
    func contextMenuWillHide()
    func hideToolbarButtonTapped()
    func versionRequestButtonTapped(with contentMode: WKWebpagePreferences.ContentMode)
}

class AaButton: UIButton {
    private lazy var hideToolbarAction = UIAction(
        title: "Hide Toolbar",
        image: UIImage(systemName: "arrow.up.left.and.arrow.down.right")
    ) { _ in
        self.delegate?.hideToolbarButtonTapped()
    }
    
    weak var delegate: AaButtonDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sendActions(for controlEvents: UIControl.Event) {
        super.sendActions(for: controlEvents)
        if
            #available(iOS 14.0, *),
            controlEvents.contains(.menuActionTriggered) {
            delegate?.contextMenuWillShow()
        }
    }
    
    override func menuAttachmentPoint(for configuration: UIContextMenuConfiguration) -> CGPoint {
        let offset = CGPoint(x: 0, y: -28)
        return offset
    }
    
    override func contextMenuInteraction(_ interaction: UIContextMenuInteraction, willEndFor configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionAnimating?) {
        if #available(iOS 14.0, *) {
            super.contextMenuInteraction(interaction, willEndFor: configuration, animator: animator)
            delegate?.contextMenuWillHide()
        }
    }
}

extension AaButton {
    func setupContextMenu(for contentMode: WKWebpagePreferences.ContentMode) {
        guard #available(iOS 14.0, *) else { return }
        
        let versionRequestAction = UIAction(
            title: contentMode == .desktop ? "Request Mobile Website" : "Request Desktop Website",
            image: UIImage(systemName: "desktopcomputer")
        ) { _ in
            switch contentMode {
            case .desktop:
                self.delegate?.versionRequestButtonTapped(with: .mobile)
            default:
                self.delegate?.versionRequestButtonTapped(with: .desktop)
            }
        }
        let children = [versionRequestAction, hideToolbarAction]
        let menu = UIMenu(options: .displayInline, children: children)
        
        self.menu = menu
    }
}
