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
    func hostHasChanged()
    func backForwardListHasChanged(_ canGoBack: Bool, _ canGoForward: Bool)
    func activateToolbar()
}

final class TabViewController: UIViewController {
    private lazy var tabView = TabView()
    private lazy var tabModel = TabModel(webView: tabView.webView)
    
    private let filterListModel: FilterListModel
    lazy var hasLoadedURl = false
    lazy var startYOffset: CGFloat = 0.0
    
    var currentURL: URL? {
        tabView.webView.url
    }
    
    private var urlHost: String?
    
    var urlObserver: NSKeyValueObservation?
    var progressObserver: NSKeyValueObservation?
    var themeColorObserver: NSKeyValueObservation?
    var underPageColorObserver: NSKeyValueObservation?
    var canGoBackObserver: NSKeyValueObservation?
    var canGoForwardObserver: NSKeyValueObservation?
    
    weak var delegate: TabViewControllerDelegate?
    
    ///// ?????? maybe remove alpha and transform to separate method
    init(isHidden: Bool, with filterListModel: FilterListModel) {
        self.filterListModel = filterListModel
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
        let webView = tabView.webView
        webView.load(URLRequest(url: url))
        hasLoadedURl = true
        hideEmptyStateIfNedded()
    }
    
    func updateWebpagePreferencesWith(contentMode: WKWebpagePreferences.ContentMode = .mobile) {
        tabView.webView.configuration.defaultWebpagePreferences.preferredContentMode = contentMode
        tabView.webView.reload()
    }
    
    func getBackItemContentMode() -> WKWebpagePreferences.ContentMode {
        tabModel.getBackItemContentMode()
    }
    
    func getForwardItemContentMode() -> WKWebpagePreferences.ContentMode {
        tabModel.getForwardItemContentMode()
    }
    
    func reload() {
        tabView.webView.reload()
    }
    
    func goBack() {
        let webView = tabView.webView
        if webView.backForwardList.backList.isEmpty {
        showEmptyState()
        }
        webView.goBack()
    }
    
    func goForward() {
        let webView = tabView.webView
        webView.goForward()
    }
    
    func backForwardButtonStatus() -> (canGoBack: Bool, canGoForward: Bool) {
        return (tabView.webView.canGoBack, tabView.webView.canGoForward)
    }
    
    func showEmptyState() {
        tabView.showEmptyStateView()
    }
    
    func hideEmptyStateIfNedded() {
        guard hasLoadedURl else { return }
        tabView.hideEmptyStateView()
    }
    
    func hasURLHostChanged(in url: URL) -> Bool {
        if urlHost == url.host {
            return false
        } else {
            urlHost = url.host
            return true
        }
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
            print("*** URL HOST CHANGED ***")
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
        canGoBackObserver = tabView.webView.observe(\WKWebView.canGoBack, options: .new) { webView, _
            in
            self.delegate?.backForwardListHasChanged(webView.canGoBack, webView.canGoForward)
        }
    }
    
    func startCanGoForwardObserve() {
        canGoForwardObserver = tabView.webView.observe(\WKWebView.canGoForward, options: .new) { webView, _ in
            self.delegate?.backForwardListHasChanged(webView.canGoBack, webView.canGoForward)
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
        guard let url = navigationAction.request.url else { return }
        switch navigationAction.navigationType {
        case .linkActivated:
            guard filterListModel.isAllowedURL(url) else {
                self.present(tabView.createPageBlockedDialogBox(), animated: true)
                decisionHandler(.cancel)
                return
            }
            
            if hasURLHostChanged(in: url) || url.query != nil {
                updateWebpagePreferencesWith(contentMode: .mobile)
                delegate?.hostHasChanged()
            }
            self.loadWebsite(from: url)
        case .formSubmitted:
            self.loadWebsite(from: url)
        default:
            break
        }
        delegate?.activateToolbar()
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        tabModel.updateCurrentItemContentMode()
        print("*** Did Finish Navigation ---- Current URL: \(webView.url?.absoluteString ?? "No URL") ***")
    }
}
