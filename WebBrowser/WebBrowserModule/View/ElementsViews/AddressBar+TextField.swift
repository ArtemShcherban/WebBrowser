//
//  AddressBar+TextField.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

extension AddressBar.TextField {
    enum State {
        case editing
        case inactive
    }
}

extension AddressBar {
    final class TextField: UITextField {
        private lazy var paddingView = UIView()
        private lazy var magnifyingGlassImageView = UIImageView()
        private lazy var aAButton = UIButton(type: .system)
        private lazy var reloadButton = UIButton(type: .system)
        
        var activityState = State.inactive {
            didSet {
                switch activityState {
                case .editing:
                    placeholder = nil
                    leftView = paddingView
                    rightView = nil
                    selectAll(nil)
                    textColor = .black
                case .inactive:
                    showDefaultPlaceholder()
                    leftView = hasText ? aAButton : magnifyingGlassImageView
                    rightView = hasText ? reloadButton : nil
                    textColor = .clear
                }
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
            let width: CGFloat

            switch activityState {
            case .editing:
                width = 5.0
            case .inactive:
                width = 30.0
            }

            let height: CGFloat = 22.0
            let y = (bounds.height - height) / 2

            return CGRect(x: 10.0, y: y, width: width, height: height)
        }
        
        override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
            let width: CGFloat = 35.0
            let height: CGFloat = 22.0
            let y = (bounds.height - height) / 2

            return CGRect(x: bounds.width - width - 5.0, y: y, width: width, height: height)
        }
        
        override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
            var rect = super.clearButtonRect(forBounds: bounds)
            rect.origin.x -= 15
            rect.size.width = 30
            return rect
        }
    }
}

private extension AddressBar.TextField {
    func setupView() {
        layer.cornerRadius = 12
        backgroundColor = .white
        clearButtonMode = .whileEditing
        returnKeyType = .go
        leftViewMode = .always
        rightViewMode = .always
        autocorrectionType = .no
        autocapitalizationType = .none
        keyboardType = .webSearch
        enablesReturnKeyAutomatically = true
        clipsToBounds = true
        setupMagnifyingGlassImageView()
        setupAaButton()
        setupReloadButton()
        activityState = .inactive
    }
    
    func setupMagnifyingGlassImageView() {
        magnifyingGlassImageView.image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        magnifyingGlassImageView.tintColor = UIColor.textFieldGray
        magnifyingGlassImageView.contentMode = .scaleAspectFit
    }
    
    func setupAaButton() {
        aAButton.setImage(UIImage(systemName: "textformat.size")?.withRenderingMode(.alwaysTemplate), for: .normal)
        aAButton.tintColor = .black
        aAButton.contentMode = .scaleAspectFit
    }
    
    func setupReloadButton() {
        reloadButton.setImage(UIImage(systemName: "arrow.clockwise")?.withRenderingMode(.alwaysTemplate), for: .normal)
        reloadButton.tintColor = .black
        reloadButton.contentMode = .scaleAspectFit
    }
    
    func showDefaultPlaceholder() {
        let attributies: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.textFieldGray]
        attributedPlaceholder = NSAttributedString(string: "Search or enter website", attributes: attributies)
    }
}
