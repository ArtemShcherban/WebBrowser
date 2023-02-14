//
//  LandscapeWebBrowserView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 09.02.2023.
//

import UIKit

final class LandscapeBrowserView: UIView {
    private lazy var toolbar = Toolbar(position: .top)
    private(set) lazy var addressBar = AddressBar()
    
    private var contentView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addСontentOf(_ tabView: LandscapeTabView) {
        contentView = tabView
        setupContentView()
    }
}

private extension LandscapeBrowserView {
    func setupView() {
        backgroundColor = .white
        setupAddressBar()
        setupToolbar()
//        setupWebPageView()
    }
    
    func setupAddressBar() {
        addSubview(addressBar)
        addressBar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addressBar.topAnchor.constraint(equalTo: self.topAnchor),
            addressBar.widthAnchor.constraint(equalToConstant: Interface.screenWidth * 0.5),
            addressBar.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setupToolbar() {
        insertSubview(toolbar, belowSubview: addressBar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: self.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolbar.heightAnchor.constraint(equalTo: addressBar.heightAnchor)
        ])
    }
    
    func setupContentView() {
        guard let contentView else { return }
        insertSubview(contentView, belowSubview: toolbar)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 3),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
