//
//  HorizontalTabView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit

class HorizontalTabView: SuperTabView {
    init(favoritesModel: FavoritesModel) {
        super.init(favoritesView: FavoritesView(favoritesModel: favoritesModel))
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HorizontalTabView {
    func setupView() {
        setupWebView()
        setupFavoritesView()
    }
    
    func setupWebView() {
        addSubview(webView)
        webView.scrollView.layer.masksToBounds = false
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
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
            favoritesView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
