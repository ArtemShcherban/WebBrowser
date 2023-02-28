//
//  ViewsTabControllersETC.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit
import WebKit

protocol BrowserViewDelegate: AnyObject {
    func goBackButtonTapped()
    func goForwardButtontTapped()
    func heartButtonTapped()
    func plusButtonTapped()
    func listButtonTapped()
}

class BrowserView: UIView {
    var toolbar: Toolbar
    var addressBars: [AddressBar] {
        return  []
    }
    var dialogBox: DialogBox?

    weak var controller: BrowserViewController?
    
    init(toolbar: Toolbar) {
        self.toolbar = toolbar
        super.init(frame: .zero)
        setupToolbarButtons()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDialogBox() {
        setupDialogBox()
        guard let dialogBox = dialogBox else { return }
        addSubview(dialogBox)
        dialogBox.setConstraints()
    }
    
    func disableToolbarButtons() {
        toolbar.items?.forEach { $0.isEnabled = false }
    }
    
    func enableToolbarButtons(
        with backForwardButtonStatus: (canGoBack: Bool, canGoForward: Bool),
        and heartButtonisEnabled: Bool
    ) {
        backForwardButtonStatusChanged(status: backForwardButtonStatus)
        toolbar.heartButton.isEnabled = heartButtonisEnabled
        toolbar.plusButton.isEnabled = true
        toolbar.listButton.isEnabled = true
        toolbar.addTabButton?.isEnabled = true
    }
    
    func backForwardButtonStatusChanged(status: (canGoBack: Bool, canGoForward: Bool)) {
        toolbar.goBackButton.isEnabled = status.canGoBack
        toolbar.goForwardButton.isEnabled = status.canGoForward
    }
}

extension BrowserView {
    func setupToolbarButtons() {
        toolbar.items?.forEach { $0.target = self }
        toolbar.goBackButton.action = #selector(goBackButtonTapped)
        toolbar.goForwardButton.action = #selector(goForwardButtontTapped)
        toolbar.heartButton.action = #selector(heartButtonTapped)
        toolbar.addTabButton?.action = #selector(addTabButtonTapped)
        toolbar.plusButton.action = #selector(plusButtonTapped)
        toolbar.listButton.action = #selector(listButtonTapped)
    }
    
    private func setupDialogBox() {
        dialogBox = DialogBox()
        setDialogBoxTargets()
        dialogBox?.textField.becomeFirstResponder()
    }
    
    private func setDialogBoxTargets() {
        dialogBox?.addButton.addTarget(
            controller,
            action: #selector(controller?.dialogBoxAddFilterButtonTapped),
            for: .touchUpInside
        )
        dialogBox?.cancelButton.addTarget(
            controller,
            action: #selector(controller?.cancelButtonTapped),
            for: .touchUpInside
        )
    }
}

@objc private extension BrowserView {
    func goBackButtonTapped() {
        controller?.goBackButtonTapped()
    }
    
    func goForwardButtontTapped() {
        controller?.goForwardButtontTapped()
    }
    
    func heartButtonTapped() {
        controller?.heartButtonTapped()
    }
    
    func addTabButtonTapped() {
        controller?.addTabButtonTapped()
    }
    
    func plusButtonTapped() {
        controller?.plusButtonTapped()
    }
    
    func listButtonTapped() {
        controller?.listButtonTapped()
    }
}
