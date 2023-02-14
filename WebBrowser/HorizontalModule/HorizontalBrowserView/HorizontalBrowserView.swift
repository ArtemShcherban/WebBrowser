//
//  HorizontalBrowserView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit

protocol HorizontalBrowserViewDelegate: AnyObject {
    func addTabButtonTapped()
}

class HorizontalBrowserView: BrowserView {
    private let topToolbar = Toolbar(position: .top)
    private let addressBar = AddressBar()
    private var contentView = UIView()
    
    var addressBarBottomConstraint: NSLayoutConstraint?
    var toolbarTopContstraint: NSLayoutConstraint?
    
    init() {
        super.init(toolbar: topToolbar)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var addressBars: [AddressBar] {
        [addressBar]
    }
    
    func addAddressBar() {
        addressBar.controller = controller
//        setupAddressBar()
    }
    
    func addСontentOf(_ tabView: SuperTabView) {
        if let controller = controller as? HorizontalBrowserController {
            tabView.webView.scrollView.delegate = controller
            tabView.webView.scrollView.scrollsToTop = true
        }
        contentView.addSubview(tabView)
        if contentView.subviews.count > 1 {
            contentView.subviews.first?.removeFromSuperview()
        }
        setConstraintsFor(tabView)
    }
}

private extension HorizontalBrowserView {
    func setupView() {
        backgroundColor = .white
        setupToolbar()
        setupAddressBar()
        setupContentView()
    }
    
    func setupAddressBar() {
        addSubview(addressBar)
        addressBar.translatesAutoresizingMaskIntoConstraints = false
        
        addressBarBottomConstraint = addressBar.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor)
    
        guard let addressBarBottomConstraint else { return }

        NSLayoutConstraint.activate([
            addressBarBottomConstraint,
            addressBar.widthAnchor.constraint(equalToConstant: Interface.screenWidth * 0.5),
            addressBar.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setupToolbar() {
        addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false

        toolbarTopContstraint = toolbar.topAnchor.constraint(
            equalTo: self.topAnchor,
            constant: 0.0
        )
        guard let toolbarTopContstraint else { return }
        
        NSLayoutConstraint.activate([
            toolbarTopContstraint,
            toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    func setupContentView() {
        insertSubview(contentView, belowSubview: toolbar)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 0),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setConstraintsFor(_ tabView: SuperTabView) {
        tabView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tabView.topAnchor.constraint(equalTo: contentView.topAnchor),
            tabView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            tabView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            tabView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
}
