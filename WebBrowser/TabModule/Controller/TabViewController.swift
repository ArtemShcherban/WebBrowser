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
    
    func tabViewController(_ tabViewController: TabViewController, selected: Bookmark)
    
    func hostHasChanged()
    func backForwardListHasChanged(_ canGoBack: Bool, _ canGoForward: Bool)
    func heartButtonEnabled()
    func activateToolbar()
    func hideKeyboard()
}

final class TabViewController: UIViewController {
    private lazy var tabView = TabView(favoritesView: favoritesView)
    private(set) lazy var favoritesView = FavoritesView(delegate: self)
    private lazy var tabModel = TabModel(webView: tabView.webView)
    private(set) lazy var favoritesModel = FavoritesModel(webView: tabView.webView)
    private let filterListModel: FilterListModel
    
    lazy var hasLoadedURl = false
    lazy var startYOffset: CGFloat = 0.0
    
    var currentURL: URL? {
        tabView.webView.url
    }
    
    private var urlHost: String?
    
    private var urlObserver: NSKeyValueObservation?
    private var progressObserver: NSKeyValueObservation?
    private var themeColorObserver: NSKeyValueObservation?
    private var underPageColorObserver: NSKeyValueObservation?
    private var canGoBackObserver: NSKeyValueObservation?
    private var canGoForwardObserver: NSKeyValueObservation?
    
    weak var delegate: TabViewControllerDelegate?
    
    ///// ?????? maybe remove alpha and transform to separate method
    init(isHidden: Bool, with filterListModel: FilterListModel) {
        self.filterListModel = filterListModel
        super.init(nibName: nil, bundle: nil)
        favoritesModel.updateBookmarks()
        self.view.alpha = isHidden ? 0 : 1
        self.view.transform = isHidden ? CGAffineTransform(scaleX: 0.8, y: 0.8) : .identity
        self.showFavoritesView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let isBackgroundColorDark = tabView.statusBarBackgroundView.backgroundColor?.isDark ?? false
        return isBackgroundColorDark ? .lightContent : .darkContent
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
        hideFavoritesViewIfNedded()
        delegate?.activateToolbar()
    }
    
    func updateWebpagePreferences(with contentMode: WKWebpagePreferences.ContentMode) {
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
    
    func addBookmark(with domain: String) {
        favoritesModel.saveBookmark(with: domain)
    }
    
    func showFavoritesView() {
        favoritesView.collectionView.reloadData()
        tabView.showFavoritesView()
        updateStatusBarColor()
    }
    
    func hasURLHostChanged(in url: URL) -> Bool {
        if urlHost == url.host {
            return false
        } else {
            urlHost = url.host
            return true
        }
    }
    
    func moveCellAt(_ sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        favoritesModel.replaceBookmarksAt(sourceIndexPath, withAt: destinationIndexPath)
    }
    
    func cancelButton(isHidden: Bool) {
        favoritesView.cancelButtonHidden(isHidden, hasLoadedURL: hasLoadedURl)
    }
    
    func finishEditingModeIfNeeded() {
        if favoritesView.collectionView.isEditingMode {
            favoritesView.editingIsFinished()
        }
    }
}

private extension TabViewController {
    func setupWebView() {
        tabView.webView.scrollView.panGestureRecognizer.addTarget(
            self,
            action: #selector(handlePan(_:))
        )
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
            self.delegate?.heartButtonEnabled()
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
        var color: UIColor
        if favoritesView.alpha == 0 {
            color = tabView.webView.themeColor ?? tabView.webView.underPageBackgroundColor ?? .white
        } else {
            color = .white
        }
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
        var yOffset: CGFloat = 0.0
        
        if let collectionView = panGestureRecognizer.view as? BookmarksCollectionView {
            yOffset = collectionView.contentOffset.y
        } else {
            yOffset = tabView.webView.scrollView.contentOffset.y
        }
        
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
                updateWebpagePreferences(with: .mobile)
                delegate?.hostHasChanged()
            }
            self.loadWebsite(from: url)
        case .formSubmitted:
            self.loadWebsite(from: url)
        default:
            break
        }
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        tabModel.updateCurrentItemContentMode()
    }
}

extension TabViewController: FavoritesViewDelegate {
    func cancelButtonTapped() {
        delegate?.hideKeyboard()
    }
    
    func trashButtonTapped() {
        guard let indexPaths = favoritesView.collectionView.indexPathsForSelectedItems else { return }
        favoritesModel.deletebookmark(at: indexPaths)
        favoritesView.collectionViewDeleteCells(at: indexPaths)
    }
    
    func collectionViewDidScroll(_ sender: UIPanGestureRecognizer) {
        delegate?.hideKeyboard()
    }
    
    func hideFavoritesViewIfNedded() {
        guard hasLoadedURl else { return }
        tabView.hideFavoritesView()
        updateStatusBarColor()
    }
}
