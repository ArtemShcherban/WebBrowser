//
//  HorizontalTabView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit

class HorizontalTabView: TabView {
    private(set) var favoritesPopUpView: FavoritesPopUpView?
    
    override init() {
        super.init()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showFavoritesPopUpView() {
        addGestureRecognizersToWebView()
        setupFavoritesPopUpView()
    }
    
    override func hideFavoritesView() {
        guard favoritesPopUpView != nil else {
            super.hideFavoritesView()
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.favoritesPopUpView?.alpha = 0
        }
        self.favoritesPopUpView?.removeFromSuperview()
        self.favoritesPopUpView = nil
        removeGestureRecognizersFromWebView()
    }
}

private extension HorizontalTabView {
    func setupView() {
        backgroundColor = .white
        layer.masksToBounds = false
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
    
    func setupFavoritesPopUpView() {
        favoritesPopUpView = FavoritesPopUpView()
        guard let favoritesPopUpView else { return }
        favoritesPopUpView.delegate = tabController
        favoritesPopUpView.tabController = tabController
        addSubview(favoritesPopUpView)
        
        favoritesPopUpView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoritesPopUpView.topAnchor.constraint(equalTo: self.topAnchor),
            favoritesPopUpView.widthAnchor.constraint(equalToConstant: Interface.screenWidth * 0.65),
            favoritesPopUpView.heightAnchor.constraint(equalToConstant: Interface.screenHeight - 120),
            favoritesPopUpView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func addGestureRecognizersToWebView() {
        webView.scrollView.panGestureRecognizer.addTarget(self, action: #selector(hideFavoritesPopUpView))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideFavoritesPopUpView))
        tapGesture.delegate = self
        webView.scrollView.addGestureRecognizer(tapGesture)
    }
    
    func removeGestureRecognizersFromWebView() {
        webView.scrollView.panGestureRecognizer.removeTarget(self, action: #selector(hideFavoritesPopUpView))
        webView.scrollView.gestureRecognizers?.removeLast()
    }
}

@objc private extension HorizontalTabView {
    func hideFavoritesPopUpView() {
        tabController?.controller?.dismissKeyboard()
        hideFavoritesView()
    }
}

extension HorizontalTabView: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}
