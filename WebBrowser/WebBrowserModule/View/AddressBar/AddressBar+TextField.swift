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

protocol TextFieldDelegate: UITextFieldDelegate {
    func textFieldTextHasChanged()
    func reloadButtonTapped()
}

extension AddressBar {
    final class TextField: UITextField {
        private lazy var paddingView = UIView()
        private lazy var magnifyingGlassImageView = UIImageView()
        lazy var reloadButton = UIButton(type: .system)
        
        lazy var aAButton: AaButton? = {
            if #available(iOS 14.0, *) {
                let aAButton = AaButton(type: .system)
                aAButton.showsMenuAsPrimaryAction = true
                return aAButton
            }
            return nil
        }()
        
        var activityState = State.inactive {
            didSet {
                switch activityState {
                case .editing:
                    placeholder = nil
                    leftView = paddingView
                    rightView = nil
                    selectAll(nil)
                    textColor = .clear
                case .inactive:
                    showDefaultPlaceholder()
                    leftView = hasText ? aAButton : magnifyingGlassImageView
                    rightView = hasText ? reloadButton : paddingView
                    textColor = .clear
                }
            }
        }
        
        weak var owner: TextFieldDelegate? {
            didSet {
                delegate = owner
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
            var width: CGFloat
            
            switch activityState {
            case .editing:
                width = 35
            case .inactive:
                width = 30
            }
            
            let height: CGFloat = 22.0
            let y = (bounds.height - height) / 2

            return CGRect(x: bounds.width - width - 5, y: y, width: width, height: 22)
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
        addTarget(self, action: #selector(textHasChangedDelegateAction), for: .editingChanged)
        reloadButton.addTarget(self, action: #selector(reloadDelegateAction), for: .touchUpInside)
    }
    
    @objc private func textHasChangedDelegateAction() {
        owner?.textFieldTextHasChanged()
    }
    
    @objc private func reloadDelegateAction() {
        owner?.reloadButtonTapped()
    }
    
    func setupMagnifyingGlassImageView() {
        magnifyingGlassImageView.image = UIImage(
            systemName: "magnifyingglass"
        )
        magnifyingGlassImageView.image?.withRenderingMode(.alwaysTemplate)
        magnifyingGlassImageView.tintColor = UIColor.textFieldGray
        magnifyingGlassImageView.contentMode = .scaleAspectFit
    }
    
    func setupAaButton() {
        guard let aAButton else { return }
        aAButton.alpha = 0

        let scaleConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        aAButton.setImage(
            UIImage(
            systemName: "textformat.size",
            withConfiguration: scaleConfiguration
            ), for: .normal
        )
        aAButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        aAButton.tintColor = .black
        aAButton.contentMode = .scaleAspectFit
    }
    
    func setupReloadButton() {
        reloadButton.alpha = 0
        let scaleConfiguration = UIImage.SymbolConfiguration(scale: .medium)
        reloadButton.setImage(
            UIImage(
            systemName: "arrow.clockwise",
            withConfiguration: scaleConfiguration
            ), for: .normal
        )
        reloadButton.imageView?.image?.withRenderingMode(.alwaysTemplate)
        reloadButton.tintColor = .black
        reloadButton.contentMode = .scaleAspectFit
    }
    
    func showDefaultPlaceholder() {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributies: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textFieldGray,
            .paragraphStyle: paragraphStyle
        ]
        attributedPlaceholder = NSAttributedString(string: "Search or enter website", attributes: attributies)
    }
}
