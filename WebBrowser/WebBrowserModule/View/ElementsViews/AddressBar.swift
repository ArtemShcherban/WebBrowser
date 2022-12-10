//
//  AddressBar.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

protocol AddressBarDelegate: AnyObject {
    func addressBarDidBeginEditing()
    func addressBar(_ addressBar: AddressBar, didReturnWithText: String)
}

final class AddressBar: UIView {
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
}

private extension AddressBar {
    func setupView() {
        layer.masksToBounds = false
        setupContainerView()
        setupShadowView()
        setupTextField()
        setupProgressView()
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
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowRadius = 4
        layer.shadowOpacity = 0.5
        containerView.addSubview(shadowView)
    }
    
    func setupTextField() {
        textField.delegate = self
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
    
    func setupProgressView() {
        progressView.alpha = 0
        progressView.tintColor = .loadingBlue
        progressView.trackTintColor = .clear
        textField.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 3.0)
        ])
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
                    self.progressView.alpha = 0
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
}

extension AddressBar: UITextFieldDelegate {
    func textFieldDidBeginEditing(_: UITextField) {
        textField.text = text
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
