//
//  LandscapeTabView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.02.2023.
//

import UIKit
import WebKit

final class LandscapeTabView: UIView {
    var favoritesView: BookmarksView
    
    lazy var webView = WKWebView(frame: CGRect(
        x: 0,
        y: 0,
        width: 0.1,
        height: 0.1)
    )
    
    init(favoritesView: BookmarksView) {
        self.favoritesView = favoritesView
        super.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func showFavoritesView() {
//        favoritesView.alpha = 1
//    }
    
    func hideFavoritesView() {
        UIView.animate(withDuration: 0.2) {
            self.favoritesView.alpha = 0
        }
    }
}

private extension LandscapeTabView {
    func setupView() {
        backgroundColor = UIColor(white: 0.97, alpha: 1)
        setupWebView()
        setupFavoritesView()
    }
    
    func setupWebView() {
        //        insertSubview(webView, belowSubview: toolbar)
        addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            //            webView.topAnchor.constraint(equalTo: self.toolbar.bottomAnchor, constant: 3),
            webView.topAnchor.constraint(equalTo: self.topAnchor),
            webView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupFavoritesView() {
        addSubview(favoritesView)
        favoritesView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoritesView.topAnchor.constraint(equalTo: self.topAnchor),
            favoritesView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            favoritesView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            favoritesView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
