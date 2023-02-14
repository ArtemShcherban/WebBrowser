//
//  AddressBar+Constraints.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 18.01.2023.
//

import UIKit

extension AddressBar {
    func setupView() {
        layer.masksToBounds = false
        setupContainerView()
        setupShadowView()
        setupTextField()
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
        shadowView.alpha = Interface.orientation == .portrait ? 1 : 0
        containerView.addSubview(shadowView)
    }
    
    func textFieldConstraint<T>(for anchor: NSLayoutAnchor<T>) -> NSLayoutConstraint? {
        switch anchor {
        case textField.heightAnchor:
            return textField.heightAnchor.constraint(equalToConstant: 0)
        case textField.leadingAnchor:
            return textField.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor,
                constant: textFieldPadding
            )
        case textField.trailingAnchor:
            return textField.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor,
                constant: -textFieldPadding
            )
        default:
            break
        }
        return nil
    }
    
    func setupTextField() {
        containerView.addSubview(textField)
        textField.translatesAutoresizingMaskIntoConstraints = false
        guard
            let textFieldLeadingConstraint,
            let textFieldTrailingConstraint,
            let textFieldHeightConstraint  else { return }
        
        textFieldHeightConstraint.constant = Interface.orientation == .portrait ? 46 : 40
            
        NSLayoutConstraint.activate([
            textFieldHeightConstraint,
            textFieldLeadingConstraint,
            textFieldTrailingConstraint,
            textField.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
    }
    
    func domainLabelConstraint(for anchor: NSLayoutXAxisAnchor) -> NSLayoutConstraint? {
        switch anchor {
        case domainLabel.trailingAnchor:
            return domainLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: textField.trailingAnchor,
                constant: -35
            )
        case domainLabel.centerXAnchor:
            return domainLabel.centerXAnchor.constraint(equalTo: textField.centerXAnchor)
        default:
            break
        }
        return nil
    }
    
    func maxLeadingConstraint() -> NSLayoutConstraint? {
        domainLabel.leadingAnchor.constraint(lessThanOrEqualTo: textField.leadingAnchor, constant: 300)
    }
    
    func minLeadingConstraint() -> NSLayoutConstraint? {
        domainLabel.leadingAnchor.constraint(greaterThanOrEqualTo: textField.leadingAnchor, constant: 40)
    }
    
    func setupDomainLabel() {
        domainLabel.alpha = 0
        domainLabel.textAlignment = .left
        domainLabel.backgroundColor = .clear
        containerView.addSubview(domainLabel)
        domainLabel.translatesAutoresizingMaskIntoConstraints = false
        
        guard
            let domainLabelMaxLeadingConstraint,
            let domainLabelMinLeadingConstraint,
            let domainLabelCenterXConstraint else { return }
        
        NSLayoutConstraint.activate([
            domainLabelMaxLeadingConstraint,
            domainLabelMinLeadingConstraint,
            domainLabelCenterXConstraint,
            domainLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func setupAddressBarProgressView() -> UIProgressView {
        let addressBarProgressView = UIProgressView()
        addressBarProgressView.alpha = 0
        addressBarProgressView.tintColor = .loadingBlue
        addressBarProgressView.trackTintColor = .clear
        addSubview(addressBarProgressView)
        addressBarProgressView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let superview = self.superview else { return UIProgressView() }
        let widthOffset = superview.frame.minX
        
        NSLayoutConstraint.activate([
            addressBarProgressView.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: -widthOffset),
            addressBarProgressView.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: widthOffset),
            addressBarProgressView.heightAnchor.constraint(equalToConstant: 3.0)
        ])
        
        if Interface.orientation == .portrait {
            addressBarProgressView.bottomAnchor.constraint(
                equalTo: textField.topAnchor
            ).isActive = true
        } else {
            addressBarProgressView.bottomAnchor.constraint(
                equalTo: textField.bottomAnchor,
                constant: -10
            ).isActive = true
        }
        return addressBarProgressView
    }
    
    func setupTextFieldProgressView() -> UIProgressView {
        let textFieldProgressView = UIProgressView()
        textFieldProgressView.alpha = 1
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
        return textFieldProgressView
    }
}
