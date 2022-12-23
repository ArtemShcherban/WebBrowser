//
//  TabView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 04.12.2022.
//

import UIKit
import WebKit

final class TabView: UIView {
    private(set) lazy var webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 0.1, height: 0.1))
    private(set) lazy var emptyStateView = TabEmptyStateView()
    private(set) lazy var statusBarBackgroundView = StatusBarBackgroundView()
    
    var statusBarBackgroundViewHeightConstraint: NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
    
    func showEmptyStateView() {
        UIView.animate(withDuration: 0.2) {
            self.emptyStateView.alpha = 1
        }
    }
    
    func hideEmptyStateView() {
        UIView.animate(withDuration: 0.2) {
            self.emptyStateView.alpha = 0
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
        setupEmptyView()
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
    
    func setupEmptyView() {
        emptyStateView.alpha = 0
        addSubview(emptyStateView)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            emptyStateView.topAnchor.constraint(equalTo: self.topAnchor),
            emptyStateView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            emptyStateView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            emptyStateView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
