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
    func addressBarDidBeginEditing()
    func addressBar(_ addressBar: AddressBar, didReturnWithText: String)
    func requestWebsiteVersionButtonTapped(_ isMobileVersion: Bool)
    func hideToolbarButtonTapped()
    func aAButtonMenuWillShow()
    func aAButtonMenuWillHide()
    func reloadButtonTapped()
}

final class AddressBar: UIView, UIEditMenuInteractionDelegate {
    lazy var textField = TextField()
    lazy var domainLabel = UILabel()
    lazy var containerView = UIView()
    private var text: String?
    private lazy var shadowView = UIView()
    private lazy var progressView = UIProgressView()
    
    private let textFieldPadding: CGFloat = 4
    private var textFieldLeadingConstraint: NSLayoutConstraint?
    private var textFieldTrailingConstraint: NSLayoutConstraint?
    var containerViewWidthConstraint: NSLayoutConstraint?
    
    private var progressViewLeadingConstraint: NSLayoutConstraint?
    private var progressViewTrailingConstraint: NSLayoutConstraint?
    private var progressViewBottomConstraint: NSLayoutConstraint?
    
    private var isMobileVersion = true
    
    weak var delegate: AddressBarDelegate?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        shadowView.layer.shadowPath = UIBezierPath(rect: containerView.frame).cgPath
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSideButtonsHiden(_ isHidden: Bool) {
        UIView.animate(withDuration: 0.2) {
            self.textField.leftView?.alpha = isHidden ? 0 :1
            self.textField.rightView?.alpha = isHidden ? 0 : 1
        }
    }
    
    func setLoadingProgress(_ progress: Float, animated: Bool) {
        progressView.alpha = 1
        animated ? animateProgressView(progress) : setProgress(progress)
    }
    
    func updateProgressView(addressBar isCollapsed: Bool) {
        isCollapsed ? setupAddressBarProgressView() : setupTextFieldProgressView()
    }
}

private extension AddressBar {
    func setupView() {
        layer.masksToBounds = false
        setupContainerView()
        setupShadowView()
        setupTextField()
        setupTextFieldProgressView()
        setupDomainLabel()
    }
    
    func setupContainerView() {
        containerView.layer.masksToBounds = false
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        containerViewWidthConstraint = containerView.widthAnchor.constraint(equalTo: self.widthAnchor)
        guard let containerViewWidthConstraint else { return }
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerViewWidthConstraint
        ])
    }
    
    func setupShadowView() {
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.lightGray.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 0)
        shadowView.layer.shadowRadius = 7
        shadowView.layer.shadowOpacity = 0.5
        containerView.addSubview(shadowView)
    }
    
    func setupTextField() {
        textField.delegate = self
//        textField.becomeFirstResponder()
        textField.reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
        if #available(iOS 14.0, *) {
            textField.aAButton.showsMenuAsPrimaryAction = true
        } else {
            textField.aAButton.alpha = 0
        }
        containerView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        textFieldLeadingConstraint = textField.leadingAnchor.constraint(
            equalTo: containerView.leadingAnchor,
            constant: textFieldPadding
        )
        textFieldTrailingConstraint = textField.trailingAnchor.constraint(
            equalTo: containerView.trailingAnchor,
            constant: -textFieldPadding
        )
        guard
            let textFieldLeadingConstraint,
            let textFieldTrailingConstraint else { return }
        
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 46),
            textFieldLeadingConstraint,
            textFieldTrailingConstraint,
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    func setupDomainLabel() {
        domainLabel.textAlignment = .center
        addSubview(domainLabel)
        domainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            domainLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            domainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            domainLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.65)
        ])
    }
    
    func setupAddressBarProgressView() {
        let addressBarProgressView = UIProgressView()
        addressBarProgressView.alpha = 0
        addressBarProgressView.tintColor = .loadingBlue
        addressBarProgressView.trackTintColor = .clear
        addSubview(addressBarProgressView)
        addressBarProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let superview = self.superview else { return }
        let widthOffset = superview.frame.minX
        
        NSLayoutConstraint.activate([
            addressBarProgressView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -widthOffset),
            addressBarProgressView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: widthOffset),
            addressBarProgressView.bottomAnchor.constraint(equalTo: textField.topAnchor),
            addressBarProgressView.heightAnchor.constraint(equalToConstant: 3.0)
        ])
        self.progressView = addressBarProgressView
    }
    
    func setupTextFieldProgressView() {
        let textFieldProgressView = UIProgressView()
        textFieldProgressView.alpha = 0
        textFieldProgressView.tintColor = .loadingBlue
        textFieldProgressView.trackTintColor = .clear
        textField.addSubview(textFieldProgressView)
        textFieldProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textFieldProgressView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            textFieldProgressView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            textFieldProgressView.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            textFieldProgressView.heightAnchor.constraint(equalToConstant: 3.0)
        ])
        self.progressView = textFieldProgressView
    }
    
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
    
    func showEditingStyle() {
        shadowView.isHidden = true
        domainLabel.alpha = 0
        
        textFieldLeadingConstraint?.constant = 0
        textFieldTrailingConstraint?.constant = 0
    }
    
    func showInactiveStyle() {
        shadowView.isHidden = false
        domainLabel.alpha = 1
        textFieldLeadingConstraint?.constant = textFieldPadding
        textFieldTrailingConstraint?.constant = -textFieldPadding
        textField.layoutIfNeeded()
    }
    
 public func setupTextFieldButtonMenuFor(contentMode: WKWebpagePreferences.ContentMode) {
        guard #available(iOS 14.0, *) else { return }
        
        var requestWebsiteAction: UIAction
        let hideToolbarAction = UIAction(
            title: "Hide Toolbar",
            image: UIImage(systemName: "arrow.up.left.and.arrow.down.right")
        ) { _ in
            self.delegate?.hideToolbarButtonTapped()
            print("Hide Toolbar")
        }
        
        var children: [UIMenuElement] = [hideToolbarAction]
        
        requestWebsiteAction = createRequestWebsiteActionWith(contentMode: contentMode)
        children.insert(requestWebsiteAction, at: 0)
        textField.aAButton.delegate = self
     let menu = UIMenu(options: .displayInline, children: children)
     textField.aAButton.menu = menu
    }
    
    @objc func aaaa() {
        print("MENU")
    }
    
    func createRequestWebsiteActionWith(contentMode: WKWebpagePreferences.ContentMode ) -> UIAction {
        let title = contentMode == .desktop ? "Request Mobile Website" : "Request Desktop Website"
        
        let action = UIAction(
            title: title,
            image: UIImage(systemName: "desktopcomputer")
        ) { _ in
            switch contentMode {
            case .mobile, .recommended:
                self.isMobileVersion = false
                self.delegate?.requestWebsiteVersionButtonTapped(self.isMobileVersion)
                self.setupTextFieldButtonMenuFor(contentMode: .desktop)
            case .desktop:
                self.isMobileVersion = true
                self.delegate?.requestWebsiteVersionButtonTapped(self.isMobileVersion)
                self.setupTextFieldButtonMenuFor(contentMode: .mobile)
            @unknown default:
                fatalError("ERRRRRRRRRROOOORRRR")
            }
        }
        return action
    }
    
//    func setupTextFieldButtonMenu() {
//        guard #available(iOS 14.0, *) else { return }
//
//        isMobileVersion.toggle()
//
//        var requestWebsiteAction: UIAction
//        let hideToolbarAction = UIAction(
//            title: "Hide Toolbar",
//            image: UIImage(systemName: "arrow.up.left.and.arrow.down.right")
//        ) { _ in
//            self.delegate?.hideToolbarButtonTapped()
//            print("Hide Toolbar")
//        }
//
//        var children: [UIMenuElement] = [hideToolbarAction]
//
//        switch isMobileVersion {
//        case true:
//            requestWebsiteAction = createRequestWebsiteAction(with: "Request Mobile Website")
//        case false:
//            requestWebsiteAction = createRequestWebsiteAction(with: "Request Desktop Website")
//        }
//
//        children.insert(requestWebsiteAction, at: 0)
//        textField.aAButton.menu = UIMenu(options: .displayInline, children: children)
//    }
//
//    func createRequestWebsiteAction(with title: String) -> UIAction {
//        let action = UIAction(
//            title: title,
//            image: UIImage(systemName: "desktopcomputer")
//        ) { _ in
//            self.delegate?.requestWebsiteVersionButtonTapped(self.isMobileVersion)
//            self.setupTextFieldButtonMenu()
//        }
//        return action
//    }
}

@objc private extension AddressBar {
    func reloadButtonTapped() {
        delegate?.reloadButtonTapped()
    }
}

extension AddressBar: UIMenuButtonDelegate {
    func contextMenuWillShow() {
        delegate?.aAButtonMenuWillShow()
        print("*** Button Menu Tapped ****")
    }
    
    func contextMenuWillHide() {
        delegate?.aAButtonMenuWillHide()
    }
}

extension AddressBar: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_: UITextField) -> Bool {
        delegate?.addressBarWillBeginEditing(self)
        return true
    }
    
    func textFieldDidBeginEditing(_: UITextField) {
        showEditingStyle()
        delegate?.addressBarDidBeginEditing()
        textField.activityState = .editing
    }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        text = textField.text
        showInactiveStyle()
        delegate?.addressBar(self, didReturnWithText: text ?? "")
        textField.activityState = .inactive
        return true
    }
    
    func textFieldDidEndEditing(_: UITextField) {
        textField.text = text
        showInactiveStyle()
        textField.activityState = .inactive
    }
}
