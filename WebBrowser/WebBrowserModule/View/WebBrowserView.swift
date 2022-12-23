//
//  WebBrowserView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

protocol WebBrowserViewDelegate: AnyObject {
    func goBackButtonTapped()
    func goForwardButtontTapped()
    func plusButtonTapped()
    func listButtonTapped()
    func updateFilters(with filter: String)
}

final class WebBrowserView: UIView {
    var dialogBox: DialogBox?
    var optionalDialogBox: DialogBox?
    
    lazy var cancelButton = UIButton(type: .system)
    lazy var tabScrollView = UIScrollView()
    lazy var tabsStackView = UIStackView()
    
    lazy var toolbar = Toolbar()
    lazy var addressBarScrollView = UIScrollView()
    lazy var addressBarStackView = UIStackView()
    lazy var keyboardBackgroundView = UIView()
    
    var addressBarScrollViewBottomConstraint: NSLayoutConstraint?
    var keyboardBackgroundViewBottomConstraint: NSLayoutConstraint?
    var toolbarBottomConstraint: NSLayoutConstraint?
    
    let tabStackSpacing: CGFloat = 24
    
    // AddressBar animation constants
    let addressBarWidthOffset: CGFloat = -48
    let addressBarContainerHidingWidthOffset: CGFloat = -200
    let addressBarStackViewSidePadding: CGFloat = 24
    let addressBarStackViewSpacing: CGFloat = 4
    let addressBarHiddingCenterOffset: CGFloat = 30
    
    // AddressBar expanding and collapsing constants
    let addressBarExpandingHalfwayBottomOffset: CGFloat = -22
    let addressBarExpandingFullyBottomOffset: CGFloat = -38
    let addressBarCollapsingHalfwayBottomOffset: CGFloat = -8
    let addressBarCollapsingFullyBottomOffset: CGFloat = 35 // 20
    
    // Toolbar expanding and collapsing constants
    let toolBarExpandingHalfwayBottomOffset: CGFloat = 40
    let toolBarExpandingFullyBottomOffset: CGFloat = 0
    let toolbarCollapsingHalfwayBottomOffset: CGFloat = 30
    let toolbarCollapsingFullyBottomOffset: CGFloat = 80
    
    var addressBarPageWidth: CGFloat {
        frame.width + addressBarWidthOffset + addressBarStackViewSpacing
    }
    
    var addressBars: [AddressBar] {
        addressBarStackView.arrangedSubviews as? [AddressBar] ?? []
    }
    
    weak var delegate: WebBrowserViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addToTabsStackView(_ tabView: UIView) {
        tabsStackView.addArrangedSubview(tabView)
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    func addAddressBar(isHidden: Bool, withDelegate delegate: AddressBarDelegate) {
        let addressBar = AddressBar()
        addressBar.delegate = delegate
        addressBarStackView.addArrangedSubview(addressBar)
        addressBar.translatesAutoresizingMaskIntoConstraints = false
        
        addressBar.widthAnchor.constraint(
            equalTo: self.widthAnchor,
            constant: self.addressBarWidthOffset
        ).isActive = true
        
        if isHidden {
            addressBar.containerViewWidthConstraint?.constant = addressBarContainerHidingWidthOffset
            addressBar.containerView.alpha = 0
        }
    }
    
    func cancelButtonHidden(_ isHidden: Bool) {
        cancelButton.alpha = isHidden ? 0 : 1
    }
    
    func showDialogBox() {
        setupDialogBox()
        addSubview(dialogBox ?? DialogBox())
        dialogBox?.setConstraints()
    }
    
    func createPageBlockedDialogBox() -> UIAlertController {
        let dialogBox = UIAlertController(
            title: "Page is blocked",
            message: "Please check filter's list",
            preferredStyle: .alert)

        let addOKAction = UIAlertAction(title: "OK", style: .cancel)
        
        dialogBox.addAction(addOKAction)
        return dialogBox
    }
    
    func disableToolbarButtons() {
        toolbar.items?.forEach { $0.isEnabled = false }
    }
    
    func enableToolbarButtons(with backForwardButtonStatus: (canGoBack: Bool, canGoForward: Bool)) {
        toolbar.goBackButton.isEnabled = backForwardButtonStatus.canGoBack
        toolbar.goForwardButton.isEnabled = backForwardButtonStatus.canGoForward
        toolbar.heartButton.isEnabled = false
        toolbar.plusButton.isEnabled = true
        toolbar.listButton.isEnabled = true

    }
}

private extension WebBrowserView {
    func setupView() {
        backgroundColor = UIColor(white: 0.97, alpha: 1)
        setupTabScrollView()
        setupTabStackView()
        setupToolbar()
        setupAddressBarScrollView()
        setupAddressBarStackView()
        setupKeyboardBackgroundView()
        setupCancelButton()
        setupToolbarButtons()
    }
    
    func setupTabScrollView() {
        tabScrollView.showsHorizontalScrollIndicator = false
        tabScrollView.showsVerticalScrollIndicator = false
        tabScrollView.isScrollEnabled = false
        tabScrollView.layer.masksToBounds = false
        addSubview(tabScrollView)
        tabScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabScrollView.topAnchor.constraint(equalTo: self.topAnchor),
            tabScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tabScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setupTabStackView() {
        tabsStackView.axis = .horizontal
        tabsStackView.alignment = .fill
        tabsStackView.distribution = .fillEqually
        tabsStackView.spacing = tabStackSpacing
        tabScrollView.addSubview(tabsStackView)
        tabsStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabsStackView.topAnchor.constraint(equalTo: tabScrollView.topAnchor),
            tabsStackView.leadingAnchor.constraint(equalTo: tabScrollView.leadingAnchor),
            tabsStackView.trailingAnchor.constraint(equalTo: tabScrollView.trailingAnchor),
            tabsStackView.heightAnchor.constraint(equalTo: tabScrollView.heightAnchor)
        ])
    }
    
    func setupToolbar() {
        addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarBottomConstraint = toolbar.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        guard let toolbarBottomConstraint else { return }
        
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: tabScrollView.bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 100),
            toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolbarBottomConstraint
        ])
    }
    
    func setupAddressBarScrollView() {
        addressBarScrollView.clipsToBounds = false
        addressBarScrollView.showsVerticalScrollIndicator = false
        addressBarScrollView.showsHorizontalScrollIndicator = false
        addressBarScrollView.decelerationRate = .fast
        addSubview(addressBarScrollView)
        addressBarScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        addressBarScrollViewBottomConstraint = addressBarScrollView.bottomAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.bottomAnchor,
            constant: addressBarExpandingFullyBottomOffset
        )
        guard let addressBarScrollViewBottomConstraint else { return }
        
        NSLayoutConstraint.activate([
            addressBarScrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            addressBarScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            addressBarScrollViewBottomConstraint
        ])
    }
    
    func setupAddressBarStackView() {
        addressBarStackView.clipsToBounds = false
        addressBarStackView.axis = .horizontal
        addressBarStackView.alignment = .fill
        addressBarStackView.distribution = .fill
        addressBarStackView.spacing = addressBarStackViewSpacing
        addressBarScrollView.addSubview(addressBarStackView)
        addressBarStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addressBarStackView.leadingAnchor.constraint(
                equalTo: addressBarScrollView.leadingAnchor,
                constant: addressBarStackViewSidePadding
            ),
            addressBarStackView.trailingAnchor.constraint(
                equalTo: addressBarScrollView.trailingAnchor,
                constant: -addressBarStackViewSidePadding
            ),
            addressBarStackView.topAnchor.constraint(equalTo: addressBarScrollView.topAnchor),
            addressBarStackView.bottomAnchor.constraint(equalTo: addressBarScrollView.bottomAnchor),
            addressBarStackView.heightAnchor.constraint(equalTo: addressBarScrollView.heightAnchor)
        ])
    }
    
    func setupKeyboardBackgroundView() {
        keyboardBackgroundView.backgroundColor = .keyboardGray
        keyboardBackgroundView.isHidden = true
        insertSubview(keyboardBackgroundView, belowSubview: toolbar)
        keyboardBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        keyboardBackgroundViewBottomConstraint = keyboardBackgroundView.bottomAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.bottomAnchor
        )
        guard let keyboardBackgroundViewBottomConstraint else { return }
        
        NSLayoutConstraint.activate([
            keyboardBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            keyboardBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            keyboardBackgroundView.heightAnchor.constraint(equalToConstant: 72),
            keyboardBackgroundViewBottomConstraint
        ])
    }
    
    func setupCancelButton() {
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelButton.alpha = 0
        cancelButton.setTitle("Cancel", for: .normal)
        addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24).isActive = true
    }
    
    func setupToolbarButtons() {
        toolbar.items?.forEach { $0.target = self }
        disableButtons()
        toolbar.goBackButton.action = #selector(goBackButtonTapped)
        toolbar.goForwardButton.action = #selector(goForwardButtontTapped)
        toolbar.plusButton.action = #selector(plusButtonTapped)
        toolbar.listButton.action = #selector(listButtonTapped)
    }
    
    func disableButtons() {
        toolbar.goBackButton.isEnabled = false
        toolbar.goForwardButton.isEnabled = false
        toolbar.heartButton.isEnabled = false
        //        toolbar.listButton.isEnabled = false
    }
    
    func setupDialogBox() {
        dialogBox = DialogBox()
        setDialogBoxTargets()
        dialogBox?.textField.becomeFirstResponder()
    }
    
    func setDialogBoxTargets() {
        dialogBox?.textField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        dialogBox?.addButton.addTarget(self, action: #selector(addFilterButtonTapped), for: .touchUpInside)
        dialogBox?.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
    }
    
    func updateAddFilterButton() {
        guard let count = dialogBox?.textField.text?.count else { return }
        if count >= 3 {
            dialogBox?.addButton.isEnabled = true
        } else {
            dialogBox?.addButton.isEnabled = false
        }
    }
    
    func checkForSpaces() {
        guard var text = dialogBox?.textField.text else { return }
        if text.last == " " {
            dialogBox?.textField.text?.remove(at: text.index(before: text.endIndex))
        }
    }
}

@objc private extension WebBrowserView {
    func goBackButtonTapped() {
        delegate?.goBackButtonTapped()
    }
    
    func goForwardButtontTapped() {
        delegate?.goForwardButtontTapped()
    }
    
    func plusButtonTapped() {
        delegate?.plusButtonTapped()
    }
    
    func listButtonTapped() {
        delegate?.listButtonTapped()
    }
    
    func textFieldDidChanged() {
        checkForSpaces()
        updateAddFilterButton()
    }
    
    func addFilterButtonTapped() {
        guard let text = dialogBox?.textField.text else { return }
        delegate?.updateFilters(with: text)
        dialogBox?.endEditing(true)
    }
    
    func cancelButtonTapped() {
        dialogBox?.endEditing(true)
    }
}
