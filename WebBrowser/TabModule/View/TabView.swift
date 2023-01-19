//
//  TabView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 04.12.2022.
//

import UIKit
import WebKit

final class TabView: UIView {
    private(set) var favoritesView: FavoritesView
    private(set) lazy var webView = WKWebView(
        frame: CGRect(
            x: 0,
            y: 0,
            width: 0.1,
            height: 0.1
        )
    )
   
    private(set) lazy var statusBarBackgroundView = StatusBarBackgroundView()
    
    var statusBarBackgroundViewHeightConstraint: NSLayoutConstraint?
    
    init(favoritesView: FavoritesView) {
        self.favoritesView = favoritesView
        super.init(frame: .zero)
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
    
    func showFavoritesView() {
        favoritesView.alpha = 1
    }
    
    func hideFavoritesView() {
        UIView.animate(withDuration: 0.2) {
            self.favoritesView.alpha = 0
        }
        if favoritesView.collectionView.isEditingMode {
            favoritesView.editingIsFinished()
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
}

private extension TabView {
    func setupView() {
        backgroundColor = .white
        layer.masksToBounds = false
        setupShadowView()
        setupWebView()
        setupStatusBarBackgroundView()
        setupBookmarksView()
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
        
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupBookmarksView() {
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
