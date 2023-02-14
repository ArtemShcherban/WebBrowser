//
//  VerticalBrowserView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit

class VerticalBrowserView: BrowserView {
    var optionalDialogBox: DialogBox?
    
    lazy var tabScrollView = UIScrollView()
    lazy var tabsStackView = UIStackView()
    
    lazy var addressBarScrollView = UIScrollView()
    lazy var addressBarStackView = UIStackView()
    lazy var keyboardBackgroundView = UIView()
    
    var addressBarWidthConstraint: NSLayoutConstraint?
    
    var addressBarScrollViewTopConstraint: NSLayoutConstraint?
    var addressBarScrollViewBottomConstraint: NSLayoutConstraint?
    var addressBarScrollViewWidthConstraint: NSLayoutConstraint?
    var addressBarStackViewXCenterConstraint: NSLayoutConstraint?

    var keyboardBackgroundViewBottomConstraint: NSLayoutConstraint?
    var toolbarTopConstraint: NSLayoutConstraint?
    var toolbarBottomConstraint: NSLayoutConstraint?
    
    let tabStackSpacing: CGFloat = 24
    
    // AddressBar animation constants
    var addressBarWidthOffset: CGFloat = -48
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
//    weak var delegate: WebBrowserViewDelegate?
    override var controller: BrowserViewController? {
        didSet {
            guard let controller = controller as? VerticalBrowserController else { return }
            addressBarScrollView.delegate = controller
        }
    }
    override var addressBars: [AddressBar] {
        return addressBarStackView.arrangedSubviews as? [AddressBar] ?? []
    }
    
    init() {
        let toolbar = Toolbar(position: .bottom)
        super.init(toolbar: toolbar)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// traitCollection animation at bottom //////////
    
    func addToTabsStackView(_ tabView: SuperTabView) {
        tabsStackView.addArrangedSubview(tabView)
        tabView.translatesAutoresizingMaskIntoConstraints = false
        tabView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
    }
    
    func addAddressBar(isHidden: Bool) {
        let addressBar = AddressBar()
        addressBar.controller = controller
        addressBarStackView.addArrangedSubview(addressBar)
        addressBar.translatesAutoresizingMaskIntoConstraints = false
        
        addressBarWidthConstraint = addressBar.widthAnchor.constraint(
            equalTo: self.widthAnchor)
        addressBarWidthConstraint?.isActive = true
        addressBarWidthConstraint?.constant = Interface.orientation == .portrait ?
        addressBarWidthOffset : -Interface.screenWidth * 0.5
        
        if isHidden {
            addressBar.containerViewWidthConstraint?.constant = addressBarContainerHidingWidthOffset
            addressBar.containerView.alpha = 0
        }
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
}

private extension VerticalBrowserView {
    func setupView() {
        backgroundColor = UIColor(white: 0.97, alpha: 1)
        setupTabScrollView()
        setupTabStackView()
        setupAddressBarScrollView()
        setupAddressBarStackView()
        setupToolbar()
        setupKeyboardBackgroundView()
//      setupToolbarButtons()
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
            tabScrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            tabScrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
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
    
    func setupAddressBarScrollView() {
        addressBarScrollView.clipsToBounds = false
        addressBarScrollView.showsVerticalScrollIndicator = false
        addressBarScrollView.showsHorizontalScrollIndicator = false
        addressBarScrollView.decelerationRate = .fast
        addSubview(addressBarScrollView)
        addressBarScrollView.translatesAutoresizingMaskIntoConstraints = false
                
        addressBarScrollViewTopConstraint =
        addressBarScrollView.topAnchor.constraint(equalTo: self.topAnchor)
        addressBarScrollViewBottomConstraint =
        addressBarScrollView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        addressBarScrollViewWidthConstraint =
        addressBarScrollView.widthAnchor.constraint(equalTo: self.widthAnchor)
       
        switch Interface.orientation {
        case .portrait:
            addressBarScrollViewBottomConstraint?.constant = addressBarExpandingFullyBottomOffset
            addressBarScrollViewBottomConstraint?.isActive = true
        case .landscape:
            self.addressBarScrollViewWidthConstraint?.constant = -Interface.screenWidth * 0.40
            self.addressBarStackViewXCenterConstraint?.isActive = true
            addressBarScrollViewTopConstraint?.isActive = true
            addressBarScrollViewBottomConstraint?.isActive = false
        }
        guard
            let addressBarScrollViewBottomConstraint,
            let addressBarScrollViewWidthConstraint else { return }
        
        NSLayoutConstraint.activate([
            addressBarScrollViewWidthConstraint,
//            addressBarScrollViewBottomConstraint,
            addressBarScrollView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
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
        
        addressBarStackViewXCenterConstraint = addressBarStackView.centerXAnchor.constraint(
            equalTo: addressBarScrollView.centerXAnchor
        )
//        addressBarStackViewTrailingConstraint = addressBarStackView.trailingAnchor.constraint(
//            equalTo: addressBarScrollView.trailingAnchor,
//            constant: -addressBarStackViewSidePadding
//        )
//        guard
//            let addressBarStackViewLeadingConstraint,
//            let addressBarStackViewTrailingConstraint else { return }
        
        NSLayoutConstraint.activate([
//            addressBarStackViewLeadingConstraint,
//            addressBarStackViewTrailingConstraint,
            addressBarStackView.leadingAnchor.constraint(
                greaterThanOrEqualTo: addressBarScrollView.leadingAnchor,
                constant: addressBarStackViewSidePadding
            ),
            addressBarStackView.trailingAnchor.constraint(
                lessThanOrEqualTo: addressBarScrollView.trailingAnchor,
                constant: -addressBarStackViewSidePadding
            ),
            addressBarStackView.topAnchor.constraint(equalTo: addressBarScrollView.topAnchor),
            addressBarStackView.bottomAnchor.constraint(equalTo: addressBarScrollView.bottomAnchor),
            addressBarStackView.heightAnchor.constraint(equalTo: addressBarScrollView.heightAnchor)
        ])
    }
    
    func setupToolbar() {
        insertSubview(toolbar, belowSubview: addressBarScrollView)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbarBottomConstraint = toolbar.bottomAnchor.constraint(
            equalTo: self.safeAreaLayoutGuide.bottomAnchor
        )
        guard let toolbarBottomConstraint else { return }
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: tabScrollView.bottomAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 100),
            toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolbarBottomConstraint
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
}

//private func updateInterface() {
//        switch Interface.orientation {
//        case .portrait:
//            toolbarTopConstraint?.constant = -110
//            toolbarBottomConstraint?.constant = 0
//            addressBarScrollViewBottomConstraint?.constant = addressBarExpandingFullyBottomOffset
//            addressBarStackViewXCenterConstraint?.isActive = false
//            self.addressBarWidthConstraint?.constant = addressBarWidthOffset
//            addressBarScrollView.isScrollEnabled = true
//            animateDownScrollView()
//        case .landscape:
//            toolbarTopConstraint?.constant = 0
//            toolbarBottomConstraint?.constant = 120
//            addressBarScrollView.isScrollEnabled = false
//            animateUPScrollView()
//        }
//    }
//
//    func animateDownScrollView() {
//        UIView.animateKeyframes(withDuration: 0.0, delay: 0.0) {
//            print(UIScreen.main.bounds.size)
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0) {
//                self.addressBarScrollViewBottomConstraint?.isActive = true
//                self.addressBarScrollViewTopConstraint?.isActive = false
//                self.addressBarWidthConstraint?.constant = self.addressBarWidthOffset
//                self.addressBarScrollViewWidthConstraint?.constant = 0
//                self.addressBarStackViewXCenterConstraint?.isActive = false
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.2) {
//                self.addressBarScrollView.alpha = 0
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) {
//                self.addressBarScrollView.alpha = 1
//            }
//        }
//    }
//
//    func animateUPScrollView() {
//        UIView.animateKeyframes(withDuration: 1, delay: 0) {
//            print(UIScreen.main.bounds.size)
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1) {
//                self.addressBarScrollViewBottomConstraint?.isActive = false
//                self.addressBarScrollViewTopConstraint?.isActive = true
//                self.addressBarWidthConstraint?.constant = -Interface.screenWidth * 0.5
//                self.addressBarScrollViewWidthConstraint?.constant = -450
//                self.addressBarStackViewXCenterConstraint?.isActive = true
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
//                self.addressBarScrollView.alpha = 0
//            }
//            UIView.addKeyframe(withRelativeStartTime: 0.9, relativeDuration: 0.1) {
//                self.addressBarScrollView.alpha = 1
//            }
//        }
//    }
//
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
////        updateInterface()
//    }
