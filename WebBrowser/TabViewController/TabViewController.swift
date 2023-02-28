//
//  TabViewController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit
import WebKit

class SuperTabViewController: UIViewController {
    
}

protocol TabViewControllerDelegate: AnyObject {
    func tabViewControllerDidScroll(yOffsetChange: CGFloat)
    func tabViewControllerDidEndDraging(yOffsetChange: CGFloat)
    
    func tabViewController(_ tabViewController: TabViewController, didStartLoadingURL: URL)
    func tabViewController(_ tabViewController: TabViewController, didChangeLoadingProgressTo: Float)
    func bookmarkWasSelected(_ tabViewController: TabViewController, selected: Bookmark)
    func hostHasChanged()
    func backForwardListHasChanged(_ canGoBack: Bool, _ canGoForward: Bool)
    func heartButtonEnabled(_ isEnabled: Bool)
    func activateToolbar()
    func hideKeyboard()
}

class TabViewController: UIViewController, TabModelDelegate {
    private(set) var tabView: SuperTabView
    private(set) var filterListModel: FilterListModel
    private(set) var favoritesModel: FavoritesModel
    private(set) lazy var tabModel = TabModel(webView: tabView.webView, delegate: self)
    private(set) lazy var favoritesView = tabView.favoritesView
    
    private var urlObserver: NSKeyValueObservation?
    private var progressObserver: NSKeyValueObservation?
    private var themeColorObserver: NSKeyValueObservation?
    
    var currentWebPage: Webpage {
        Webpage(
            url: tabView.webView.url,
            title: tabView.webView.title,
            error: nil,
            contentMode: .mobile
        )
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
        tabView: SuperTabView,
        filterListModel: FilterListModel,
        favoritesModel: FavoritesModel
    ) {
        self.tabView = tabView
        self.filterListModel = filterListModel
        self.favoritesModel = favoritesModel
        super.init(nibName: nil, bundle: nil)
        tabView.favoritesView.tabController = self
        tabView.tabController = self
        startWebViewObserve()
        tabView.webView.navigationDelegate = self
        tabView.setWebViewPanGestureRecignizer()
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
    
    func contentModeForNextWebPage() -> WKWebpagePreferences.ContentMode {
        tabModel.setContentModeForNextWebpage()
    }
    
    func reload() {
        tabView.webView.reload()
    }
    func goBack() {
        tabModel.goBack()
    }
    
    func goForward() {
        tabModel.goForward()
    }
    
    func addBookmark(with currentWebpage: Webpage) {
        favoritesModel.saveBookmark(with: currentWebpage)
    }
    
    func backForwardButtonStatus() -> (canGoBack: Bool, canGoForward: Bool) {
        return (tabModel.webpageBackForwardStack.canGoBack, tabModel.webpageBackForwardStack.canGoForward)
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
            selector: #selector(backForwardStackChanged),
            name: .backForwardStackChanged,
            object: nil
        )
    }
}

@objc private extension TabViewController {
    func backForwardStackChanged() {
        guard  controller?.toolbarIsHide == false else { return }
        controller?.backForwardListHasChanged(
            tabModel.webpageBackForwardStack.canGoBack,
            tabModel.webpageBackForwardStack.canGoForward
        )
    }
}
