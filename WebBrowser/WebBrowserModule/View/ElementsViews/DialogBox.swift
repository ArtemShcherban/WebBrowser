//
//  DialogBox.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.12.2022.
//

import UIKit

final class DialogBox: UIView {
    private lazy var backgroundView = UIView()
    private lazy var containerView = UIView()
    private lazy var shadowView = UIView()
    private lazy var dialogBoxView = UIView()
    private lazy var titleLabel = UILabel()
    private(set) lazy var textField = DialogBoxTextField()
    private lazy var buttonsView = UIView()
    lazy var addButton = UIButton(type: .system)
    lazy var cancelButton = UIButton(type: .system)
    
    var dialogBoxViewBottomConstraints: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        shadowView.layer.shadowPath = UIBezierPath(rect: dialogBoxView.frame).cgPath
    }
    
    func setConstraints() {
        guard let superview = superview as? WebBrowserView else { return }
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
        
        setBackgroundViewConstraints()
        setDialogBoxViewConstraints()
        setContainerViewConstraints()
        setTitleLabelConstraints()
        setButtonsViewConstraints()
        setTextFieldsConstraints()
        setAddButtonConstraints()
        setCancelButtonConstraints()
    }
}

private extension DialogBox {
    func setupView() {
        self.alpha = 0
        setupBackgroundView()
        setupShadowView()
        setupContainerView()
        setupDialogBoxView()
        setupTitleLabel()
        setupTextField()
        setupAddButton()
        setupCancelButton()
        setupButtonsView()
    }
    
    func setupBackgroundView() {
        backgroundView.backgroundColor = .black.withAlphaComponent(0.3)
        addSubview(backgroundView)
    }
    
    func setupContainerView() {
        containerView.layer.cornerRadius = 10
        containerView.backgroundColor = .green
        addSubview(containerView)
    }
    
    func setupShadowView() {
//        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowColor = UIColor.black.cgColor
        shadowView.layer.shadowOffset = CGSize(width: 4, height: 0)
        shadowView.layer.shadowRadius = 5
        shadowView.layer.shadowOpacity = 0.5
        containerView.addSubview(shadowView)
    }
    
    func setupDialogBoxView() {
        containerView.addSubview(dialogBoxView)
        dialogBoxView.clipsToBounds = true
        dialogBoxView.layer.cornerRadius = 10
        dialogBoxView.backgroundColor = UIColor(red: 241 / 255, green: 242 / 255, blue: 214 / 255, alpha: 1)
    }
    
    func setupTitleLabel() {
        let titleString = "Add filter\n"
        let stringOne = "Please enter new filter.\n"
        let stringTwo = "Minimum of 3 characters and no spaces."
        let title = NSMutableAttributedString(
            string: titleString + stringOne + stringTwo,
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18, weight: .medium)
            ])
        title.addAttributes(
            [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13)],
            range: NSRange(location: 10, length: 64)
        )
        titleLabel.numberOfLines = 0
        titleLabel.attributedText = title
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        dialogBoxView.addSubview(titleLabel)
    }
    
    func setupTextField() {
        textField.layer.cornerRadius = 6
        textField.backgroundColor = .white
        textField.font = UIFont.systemFont(ofSize: 13)
        textField.clearButtonMode = .whileEditing
        textField.textAlignment = .center
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .words
        dialogBoxView.addSubview(textField)
    }
    
    func setupAddButton() {
        addButton.isEnabled = false
        addButton.setTitle("Add Filter", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        addButton.backgroundColor = UIColor(red: 241 / 255, green: 242 / 255, blue: 214 / 255, alpha: 1)
    }
    
    func setupCancelButton() {
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelButton.backgroundColor = UIColor(red: 241 / 255, green: 242 / 255, blue: 214 / 255, alpha: 1)
    }
    
    func setupButtonsView() {
        buttonsView.backgroundColor = .lightGray
        buttonsView.addSubview(addButton)
        buttonsView.addSubview(cancelButton)
        dialogBoxView.addSubview(buttonsView)
    }
    
    func setBackgroundViewConstraints() {
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: self.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setContainerViewConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: dialogBoxView.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: dialogBoxView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: dialogBoxView.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: dialogBoxView.bottomAnchor)
        ])
    }
    
    func setDialogBoxViewConstraints() {
        dialogBoxView.translatesAutoresizingMaskIntoConstraints = false
        
        dialogBoxViewBottomConstraints = dialogBoxView.bottomAnchor.constraint(
            equalTo: backgroundView.centerYAnchor, constant: 290)
        guard let dialogBoxViewBottomConstraints else { return }
        
        NSLayoutConstraint.activate([
            dialogBoxView.heightAnchor.constraint(equalToConstant: 167),
            dialogBoxView.widthAnchor.constraint(equalToConstant: 270),
            dialogBoxView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor),
            dialogBoxViewBottomConstraints
        ])
    }
    
    func setTitleLabelConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: dialogBoxView.topAnchor, constant: 16),
            titleLabel.centerXAnchor.constraint(equalTo: dialogBoxView.centerXAnchor)
        ])
    }
    
    func setTextFieldsConstraints() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalToConstant: 26),
            textField.widthAnchor.constraint(equalTo: dialogBoxView.widthAnchor, constant: -32),
            textField.centerXAnchor.constraint(equalTo: dialogBoxView.centerXAnchor),
            textField.bottomAnchor.constraint(equalTo: buttonsView.topAnchor, constant: -12)
        ])
    }
    
    func setButtonsViewConstraints() {
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsView.heightAnchor.constraint(equalTo: dialogBoxView.heightAnchor, multiplier: 0.27),
            buttonsView.leadingAnchor.constraint(equalTo: dialogBoxView.leadingAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: dialogBoxView.trailingAnchor),
            buttonsView.bottomAnchor.constraint(equalTo: dialogBoxView.bottomAnchor)
        ])
    }
    
    func setAddButtonConstraints() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: buttonsView.topAnchor, constant: 0.5),
            addButton.leadingAnchor.constraint(equalTo: buttonsView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: buttonsView.centerXAnchor, constant: -0.25),
            addButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor)
        ])
    }
    
    func setCancelButtonConstraints() {
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.topAnchor.constraint(equalTo: buttonsView.topAnchor, constant: 0.5),
            cancelButton.leadingAnchor.constraint(equalTo: buttonsView.centerXAnchor, constant: 0.25),
            cancelButton.trailingAnchor.constraint(equalTo: buttonsView.trailingAnchor),
            cancelButton.bottomAnchor.constraint(equalTo: buttonsView.bottomAnchor)
        ])
    }
}
