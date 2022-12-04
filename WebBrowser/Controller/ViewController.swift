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
    var hasHiddenTab = false
    var isAddressBarActive = false
    var currentTabIndex = 0 {
        didSet {
            updateAddressBarsAfterTabChange()
        }
    }
    
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
        webBrowserView.addAddressBar(isHidden: isHidden, withDelegate: self)
    }
    
    func updateAddressBarsAfterTabChange() {
        currentAddressBar.isUserInteractionEnabled = true
        currentAddressBar.setSideButtonsHiden(false)
        leftAddressBar?.isUserInteractionEnabled = false
        leftAddressBar?.setSideButtonsHiden(true)
        rightAddressBar?.isUserInteractionEnabled = false
        rightAddressBar?.setSideButtonsHiden(true)
    }
}

@objc private extension ViewController {
    func cancelButtonTapped() {
        dismissKeyboard()
    }
}

extension ViewController: AddressBarDelegate {
    func addressBarDidBeginEditing() {
        isAddressBarActive = true
    }
    
    func addressBar(_ addressBar: AddressBar, didReturnWithText text: String) {
        openNewTab(isHidden: true)
        addressBar.domainLabel.text = text // remove later
        dismissKeyboard()
    }
}
