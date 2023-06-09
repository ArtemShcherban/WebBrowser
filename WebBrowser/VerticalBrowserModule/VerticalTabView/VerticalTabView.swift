//
//  VerticalTabView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit
import WebKit

final class VerticalTabView: TabView {
    private(set) lazy var statusBarBackgroundView = StatusBarBackgroundView()
    
    var statusBarBackgroundViewHeightConstraint: NSLayoutConstraint?
    var webViewTopConstraint: NSLayoutConstraint?
    
    override init() {
        super.init()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0
        statusBarBackgroundViewHeightConstraint?.constant = statusBarHeight + 20
    }
    
    override func hideFavoritesView() {
        super.hideFavoritesView()
        if favoritesView.collectionView.isEditingMode {
            favoritesView.editingIsFinished()
        }
    }
}

private extension VerticalTabView {
    func setupView() {
        backgroundColor = .white
        layer.masksToBounds = false
        setupShadowView()
        setupWebView()
        setupStatusBarBackgroundView()
        setupFavoritesView()
    }
    
    func setupShadowView() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 15
    }

    func setupStatusBarBackgroundView() {
        addSubview(statusBarBackgroundView)
        statusBarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        statusBarBackgroundViewHeightConstraint =
        statusBarBackgroundView.heightAnchor.constraint(equalToConstant: 0)
        guard let statusBarBackgroundViewHeightConstraint else { return }
        
        NSLayoutConstraint.activate([
        statusBarBackgroundViewHeightConstraint,
        statusBarBackgroundView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
        statusBarBackgroundView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
        statusBarBackgroundView.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
    
    func setupWebView() {
        webView.allowsBackForwardNavigationGestures = true
        webView.scrollView.automaticallyAdjustsScrollIndicatorInsets = false
        webView.scrollView.contentInset = .zero
        webView.scrollView.layer.masksToBounds = false
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webViewTopConstraint = webView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor)
        guard let webViewTopConstraint else { return }
        webViewTopConstraint.constant = Interface.orientation == .portrait ? 0 : 56
        
        NSLayoutConstraint.activate([
            webViewTopConstraint,
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupFavoritesView() {
        favoritesView.alpha = 0
        addSubview(favoritesView)
        favoritesView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoritesView.topAnchor.constraint(equalTo: self.topAnchor),
            favoritesView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            favoritesView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            favoritesView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
