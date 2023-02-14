//
//  AddressBar.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit
import WebKit

protocol AddressBarDelegate: AnyObject {
    func addressBarWillBeginEditing(_ addressBar: AddressBar)
    func addressBar(_ addressBar: AddressBar, didReturnWithText: String)
    func requestWebpageWith(contentMode: WKWebpagePreferences.ContentMode)
    func hideToolbar()
    func aAButtonMenuWillShow()
    func aAButtonMenuWillHide()
    func reloadCurrentWebpage()
}

final class AddressBar: UIView, UIEditMenuInteractionDelegate {
    lazy var textField: TextField = {
        let textField = TextField()
        textField.owner = self
        textField.aAButton?.delegate = self
        return textField
    }()
    
    lazy var domainLabel = UILabel()
    lazy var containerView = UIView()
    
    var addressBarText: String?
    var domainTitleString = String() {
        didSet {
            domainLabel.text = domainTitleString
        }
    }
    var isActive = false
    
    private(set) lazy var shadowView = UIView()
    private lazy var progressView = UIProgressView()
    
    let textFieldPadding: CGFloat = 4
    private(set) lazy
    var textFieldHeightConstraint = textFieldConstraint(for: textField.heightAnchor)
    private(set) lazy
    var textFieldLeadingConstraint = textFieldConstraint(for: textField.leadingAnchor)
    private(set) lazy
    var textFieldTrailingConstraint = textFieldConstraint(for: textField.trailingAnchor)
    private(set) lazy
    var domainLabelMaxLeadingConstraint = maxLeadingConstraint()
    private(set) lazy
    var domainLabelMinLeadingConstraint = minLeadingConstraint()
    private(set) lazy
    var domainLabelTrailingConstraint = domainLabelConstraint(for: domainLabel.trailingAnchor)
    private(set) lazy
    var domainLabelCenterXConstraint = domainLabelConstraint(for: domainLabel.centerXAnchor)
    
    var containerViewWidthConstraint: NSLayoutConstraint?
    
    private var isMobileVersion = true
    
    weak var controller: AddressBarDelegate?
    weak var delegate: AddressBarDelegate?
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.layer.shadowPath = UIBezierPath(rect: containerView.frame).cgPath
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        progressView = setupTextFieldProgressView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        switch Interface.orientation {
        case .portrait:
            textFieldHeightConstraint?.constant = 46
            textField.layer.cornerRadius = 12
            textField.backgroundColor = .white
            shadowView.alpha = 1
        case .landscape:
            textFieldHeightConstraint?.constant = 40
            textField.layer.cornerRadius = 10
            textField.backgroundColor = .textFieldGray
            shadowView.alpha = 0
        }
    }
    
    func setSideButtonsHiden(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.textField.leftView?.alpha = isHidden ? 0 : 1
            self.textField.rightView?.alpha = isHidden ? 0 : 1
        }
    }
    
    func setLoadingProgress(_ progress: Float, animated: Bool) {
        progressView.alpha = 1
        animated ? animateProgressView(progress) : setProgress(progress)
    }
    
    func updateProgressView(addressBar isCollapsed: Bool) {
        progressView = isCollapsed ?
        setupAddressBarProgressView() : setupTextFieldProgressView()
    }
    
    func updateAfterLoadingBookmark(text: String) {
        addressBarText = text
        textField.text = text
        textField.textColor = .black
        showInactiveStyle()
    }
    
    func showInactiveStyle() {
        if textField.activityState == .inactive {
            animateDomainLabelFirstAppearing()
        } else {
            domainLabel.alpha = 1
        }
        textField.activityState = .inactive
    }
    
    func updateAaButtonMenuFor(contentMode: WKWebpagePreferences.ContentMode) {
        textField.aAButton?.setupContextMenu(for: contentMode)
    }
}

private extension AddressBar {
    func setProgress(_ progress: Float) {
        if let layers = progressView.layer.sublayers {
            layers.forEach { layer in
                layer.removeAllAnimations()
            }
        }
        progressView.setProgress(progress, animated: false)
        progressView.setNeedsLayout()
        progressView.layoutIfNeeded()
    }
    
    func animateProgressView(_ progress: Float) {
        if progress < 1 {
            progressView.setProgress(progress, animated: true)
        } else {
            progressView.progress = progress
            UIView.animate(withDuration: 0.5, animations: {
                self.progressView.layoutIfNeeded()
            }, completion: { _ in
                self.setProgress(0)
                UIView.animate(withDuration: 0.2) {
                    self.progressView.alpha = 1
                }
            })
        }
    }
}
