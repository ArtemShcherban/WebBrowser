//
//  ViewController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

final class ViewController: UIViewController {
    lazy var webBrowserView = WebBrowserView()
    lazy var webBrowserModel = WebBrowserModel()
    lazy var hasHiddenTab = false
    lazy var isCollapsed = false
    lazy var isAddressBarActive = false
    lazy var currentTabIndex = 0 {
        didSet {
            updateAddressBarsAfterTabChange()
        }
    }
    
    var collapsingToolbarAnimator: UIViewPropertyAnimator?
    var expandingToolbarAnimator: UIViewPropertyAnimator?
    
    lazy var tabViewControllers: [TabViewController] = []
    
    var currentAddressBar: AddressBar {
        webBrowserView.addressBars[currentTabIndex]
    }
    
    var leftAddressBar: AddressBar? {
        webBrowserView.addressBars[safe: currentTabIndex - 1]
    }
    
    var rightAddressBar: AddressBar? {
        webBrowserView.addressBars[safe: currentTabIndex + 1]
    }
    
    override func loadView() {
        super.loadView()
        self.view = webBrowserView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAddressBarScrollView()
        setupKeyboardManager()
        openNewTab(isHidden: false)
        setupCancelButton()
        setupAddressBarExpandingTap()
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}

private extension ViewController {
    func setupCancelButton() {
        webBrowserView.cancelButton.addTarget(
            self,
            action: #selector(cancelButtonTapped),
            for: .touchUpInside
        )
    }
    
    func setupAddressBarScrollView() {
        webBrowserView.addressBarScrollView.delegate = self
    }
    
    func openNewTab(isHidden: Bool) {
        hasHiddenTab = isHidden
        addTabViewController(isHidden: isHidden)
        webBrowserView.addAddressBar(isHidden: isHidden, withDelegate: self)
    }
    
    func addTabViewController(isHidden: Bool) {
        let tabViewController = TabViewController(isHidden: isHidden)
        tabViewController.delegate = self
        tabViewControllers.append(tabViewController)
        addChild(tabViewController)
        tabViewController.didMove(toParent: self)
        webBrowserView.addToTabsStackView(tabViewController.view)
    }
    
    //    func addTabViewController(isHidden: Bool) {
    //        let tabViewController = TabViewController(isHidden: isHidden)
    //        tabViewController.view.alpha = isHidden ? 0 : 1
    //        tabViewController.view.transform = isHidden ? CGAffineTransform(scaleX: 0.8, y: 0.8) : .identity
    //        tabViewController.showEmptyState()
    //        tabViewController.delegate = self
    //        tabViewControllers.append(tabViewController)
    //        webBrowserView.tabsStackView.addArrangedSubview(tabViewController.view)
    //        tabViewController.view.translatesAutoresizingMaskIntoConstraints = false
    //        tabViewController.view.widthAnchor.constraint(equalTo: webBrowserView.widthAnchor).isActive = true
    //        addChild(tabViewController)
    //        tabViewController.didMove(toParent: self)
    //    }
    
    func updateAddressBarsAfterTabChange() {
        currentAddressBar.isUserInteractionEnabled = true
        currentAddressBar.setSideButtonsHiden(false)
        leftAddressBar?.isUserInteractionEnabled = false
        leftAddressBar?.setSideButtonsHiden(true)
        rightAddressBar?.isUserInteractionEnabled = false
        rightAddressBar?.setSideButtonsHiden(true)
    }
    
    func setupAddressBarExpandingTap() {
        let tapGestureRecogniser = UITapGestureRecognizer(
            target: self,
            action: #selector(addressBarTapped)
        )
        currentAddressBar.addGestureRecognizer(tapGestureRecogniser)
    }
}

@objc private extension ViewController {
    func cancelButtonTapped() {
        dismissKeyboard()
    }
    
    func addressBarTapped() {
        guard isCollapsed else { return }
            setupExpandingToolbarAnimator()
            expandingToolbarAnimator?.startAnimation()
            isCollapsed = false
    }
}

extension ViewController: AddressBarDelegate {
    func addressBarDidBeginEditing() {
        isAddressBarActive = true
    }
    
    func addressBar(_ addressBar: AddressBar, didReturnWithText text: String) {
        let tabViewController = tabViewControllers[currentTabIndex]
        let isLastTab = currentTabIndex == tabViewControllers.count - 1
        if isLastTab, !tabViewController.hasLoadedURl {
            openNewTab(isHidden: true)
        }
        if let url = webBrowserModel.getURL(for: text) {
            tabViewController.loadWebsite(from: url )
        }
        dismissKeyboard()
    }
}
