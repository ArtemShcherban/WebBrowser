//
//  TabViewController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 04.12.2022.
//

import UIKit
import WebKit

protocol TabViewControllerDelegate: AnyObject {
    func tabViewControllerDidScroll(yOffsetChange: CGFloat)
    func tabViewControllerDidEndDraging()
    func tabViewController(_ tabViewController: TabViewController, didStartLoadingURL: URL)
    func tabViewController(_ tabViewController: TabViewController, didChangeLoadingProgressTo: Float)
//    func setupToolbarButtonsAppearance()
    func tabViewControllerBackForwardListHasChanged(_ tabViewController: TabViewController)
}

class TabViewController: UIViewController {
    private(set) lazy var tabView = TabView()
    lazy var hasLoadedURl = false
    lazy var startYOffset: CGFloat = 0.0
    
    var urlObserver: NSKeyValueObservation?
    var progressObserver: NSKeyValueObservation?
    var themeColorObserver: NSKeyValueObservation?
    var underPageColorObserver: NSKeyValueObservation?
    var canGoBackObserver: NSKeyValueObservation?
    var canGoForwardObserver: NSKeyValueObservation?

    weak var delegate: TabViewControllerDelegate?
    
    init(isHidden: Bool) { ///// ?????? maybe remove alpha and transform to separate method
        super.init(nibName: nil, bundle: nil)
        self.view.alpha = isHidden ? 0 : 1
        self.view.transform = isHidden ? CGAffineTransform(scaleX: 0.8, y: 0.8) : .identity
        self.showEmptyState()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = tabView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
    }
    
    func loadWebsite(from url: URL) {
        tabView.webView.load(URLRequest(url: url))
        hasLoadedURl = true
        hideEmptyStateIfNedded()
    }
    
    func showEmptyState() {
        tabView.showEmptyStateView()
    }
    
    func hideEmptyStateIfNedded() {
        guard hasLoadedURl else { return }
        tabView.hideEmptyStateView()
    }
}

private extension TabViewController {
    func setupWebView() {
        tabView.webView.scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        tabView.webView.navigationDelegate = self
        startURLObserve()
        startProgressObserve()
        startThemeColorObserve()
        startUnderPageColorObserve()
        startCanGoBackObserve()
        startCanGoForwardObserve()
    }
    
    func startURLObserve() {
        urlObserver = tabView.webView.observe(\WKWebView.url, options: .new) { _, _ in
            guard let url = self.tabView.webView.url else { return }
            self.delegate?.tabViewController(self, didStartLoadingURL: url)
        }
    }
    
    func startProgressObserve() {
        progressObserver = tabView.webView.observe(\WKWebView.estimatedProgress, options: .new) { _, _ in
            let estimatedProgress = Float(self.tabView.webView.estimatedProgress)
            self.delegate?.tabViewController(self, didChangeLoadingProgressTo: estimatedProgress)
        }
    }
    
    func startThemeColorObserve() {
        guard #available(iOS 15.0, *) else { return }
        themeColorObserver = tabView.webView.observe(\WKWebView.themeColor, options: .new) { _, _ in
            self.updateStatusBarColor()
        }
    }
    
    func startUnderPageColorObserve() {
        guard #available(iOS 15.0, *) else { return }
        underPageColorObserver = tabView.webView.observe(\WKWebView.underPageBackgroundColor, options: .new) { _, _ in
            self.updateStatusBarColor()
        }
    }
    
    func updateStatusBarColor() {
        guard #available(iOS 15.0, *) else { return }
        let color = tabView.webView.themeColor ?? tabView.webView.underPageBackgroundColor ?? .red
        tabView.statusBarBackgroundView.setColor(color)
        setNeedsStatusBarAppearanceUpdate()
    }
    
    func startCanGoBackObserve() {
        canGoBackObserver = tabView.webView.observe(\WKWebView.canGoBack, options: .new) { _, _ in
            self.delegate?.tabViewControllerBackForwardListHasChanged(self)
        }
    }
    
    func startCanGoForwardObserve() {
        canGoForwardObserver = tabView.webView.observe(\WKWebView.canGoForward, options: .new) { _, _ in
            self.delegate?.tabViewControllerBackForwardListHasChanged(self)
        }
    }
}

@objc private extension TabViewController {
    func handlePan(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let yOffset = tabView.webView.scrollView.contentOffset.y
        switch panGestureRecognizer.state {
        case .began:
            startYOffset = yOffset
        case .changed:
            delegate?.tabViewControllerDidScroll(yOffsetChange: startYOffset - yOffset)
        case .failed, .cancelled, .ended:
            delegate?.tabViewControllerDidEndDraging()
        default:
            break
        }
    }
}

extension TabViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated {
            print("*****************")
        }
        decisionHandler(.allow)
    }
}
