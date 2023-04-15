//
//  TabViewController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit
import WebKit

protocol TabViewControllerDelegate: AnyObject {
    func tabViewControllerDidScroll(yOffsetChange: CGFloat)
    func tabViewControllerDidEndDraging(yOffsetChange: CGFloat)
    
    func tabViewController(_ tabViewController: TabViewController, didStartLoadingURL: URL)
    func tabViewController(_ tabViewController: TabViewController, didChangeLoadingProgressTo: Float)
    func bookmarkHasTapped(_ tabViewController: TabViewController, _ bookmark: Bookmark)
    func hostHasChanged()
    func backForwardListHasChanged(_ canGoBack: Bool, _ canGoForward: Bool)
    func heartButtonEnabled(_ isEnabled: Bool)
    func activateToolbar()
    func hideKeyboard()
}

class TabViewController: UIViewController {
    private(set) var tabView: TabView
    private(set) var filterListModel = FilterListModel()
    private(set) var favoritesModel = FavoritesModel()
    private(set) lazy var tabModel = TabModel(webView: tabView.webView)
    private(set) lazy var favoritesView = tabView.favoritesView
    
    private var urlObserver: NSKeyValueObservation?
    private var progressObserver: NSKeyValueObservation?
    private var themeColorObserver: NSKeyValueObservation?
    
    var currentWebpage: Webpage? {
        tabModel.currentWebpage
    }
    
    lazy var hasLoadedURl = false {
        didSet {
            guard self.controller?.toolbarIsHide == false else { return }
            self.controller?.heartButtonEnabled(hasLoadedURl)
        }
    }
    private var urlHost: String?
    var navigationError: NSError?
    var loadingWebpage: Webpage? {
        tabModel.currentWebpage
    }
    
    weak var controller: BrowserViewController?
    
    init(
        tabView: TabView
    ) {
        self.tabView = tabView
        super.init(nibName: nil, bundle: nil)
        tabView.favoritesView.delegate = self
        tabView.favoritesView.tabController = self
        tabView.tabController = self
        startWebViewObserve()
        tabView.webView.navigationDelegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startWebViewObserve() {
        startURLObserve()
        startProgressObserve()
    }
    
    func loadWebsite(from url: URL) {
        navigationError = nil
        tabModel.createWebpage(with: url)
        let webView = tabView.webView
        webView.load(URLRequest(url: url))
        hasLoadedURl = true
        hideFavoritesViewIfNedded()
        controller?.activateToolbar()
    }
    
    func hasURLHostChanged(in url: URL) -> Bool {
        if urlHost == url.host {
            return false
        } else {
            urlHost = url.host
            return true
        }
    }
    
    func reload() {
        tabView.webView.reload()
    }
    
    func go(_ direction: Direction) {
        let nextWebPage = direction == .backward ? tabModel.backWebpage : tabModel.frontWebpage
        guard
            let nextWebPage,
            let url = nextWebPage.url else { return }
        tabView.updateWebViewContentMode(for: nextWebPage)
        navigationError = nextWebPage.error
        tabView.webView.load(URLRequest(url: url))
        tabModel.updateBackForwardStackAfterMoving(direction)
    }
    
    func addBookmark(with currentWebpage: Webpage) {
        favoritesModel.saveBookmark(with: currentWebpage)
    }
    
    func backForwardButtonStatus() -> (canGoBack: Bool, canGoForward: Bool) {
        return (tabModel.canGoBack, tabModel.canGoForward)
    }
    
    func updateWebViewConfiguration(with contentMode: WKWebpagePreferences.ContentMode) {
        tabView.webView.configuration.defaultWebpagePreferences.preferredContentMode = contentMode
        guard
            let loadingWebpage,
            let url = loadingWebpage.url,
            loadingWebpage.error != nil else {
            tabView.webView.reload()
            return
        }
        tabView.webView.load(URLRequest(url: url))
    }
    
    func showFavoritesView() {
        favoritesView.collectionView.reloadData()
        tabView.showFavoritesView()
    }
}

extension TabViewController {
    private func startURLObserve() {
        urlObserver = tabView.webView.observe(\WKWebView.url, options: .new) { _, _ in
            guard let url = self.tabView.webView.url else { return }
            self.controller?.tabViewController(self, didStartLoadingURL: url)
        }
    }
    
    private func  startProgressObserve() {
        progressObserver = tabView.webView.observe(\WKWebView.estimatedProgress, options: .new) { _, _ in
            let estimatedProgress = Float(self.tabView.webView.estimatedProgress)
            self.controller?.tabViewController(self, didChangeLoadingProgressTo: estimatedProgress)
        }
    }
    
    func startBackForwardStackObserve() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(backForwardStackHasChanged),
            name: .backForwardStackHasChanged,
            object: nil
        )
    }
    
    func removeBackForwardStackObserve() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: .backForwardStackHasChanged, object: nil)
    }
}

@objc private extension TabViewController {
    func backForwardStackHasChanged() {
        guard  controller?.toolbarIsHide == false else { return }
        controller?.backForwardListHasChanged(
            tabModel.canGoBack,
            tabModel.canGoForward
        )
    }
}
