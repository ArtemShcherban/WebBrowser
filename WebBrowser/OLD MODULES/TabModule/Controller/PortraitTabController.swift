//
//  PortraitTabController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 04.12.2022.
//

import UIKit
import WebKit

protocol OLDTabViewControllerDelegate: AnyObject {
    func tabViewControllerDidScroll(yOffsetChange: CGFloat)
    func tabViewControllerDidEndDraging()
    
    func tabViewController(_ tabViewController: SuperTabViewController, didStartLoadingURL: URL)
    func tabViewController(_ tabViewController: SuperTabViewController, didChangeLoadingProgressTo: Float)
    func bookmarkWasSelected(_ tabViewController: SuperTabViewController, selected: Bookmark)
    func hostHasChanged()
    func backForwardListHasChanged(_ canGoBack: Bool, _ canGoForward: Bool)
    func heartButtonEnabled()
    func activateToolbar()
    func hideKeyboard()
}
extension OLDTabViewControllerDelegate {
    func tabViewControllerDidScroll(yOffsetChange: CGFloat) { }
    func tabViewControllerDidEndDraging() { }
}

final class PortraitTabController: SuperTabViewController {
    private(set) lazy var tabView = TabViewOLD(favoritesView: favoritesView)
    private(set) lazy var favoritesView = FavoritesView()
    private lazy var tabModel = TabModel(webView: tabView.webView)
    private(set) lazy var favoritesModel = FavoritesModel()
    private let filterListModel: FilterListModel
    
    lazy var hasLoadedURl = false
    lazy var startYOffset: CGFloat = 0.0
    
    var currentURL: URL? {
        tabView.webView.url
    }
    
    var loadingWebpage: Webpage? {
        tabModel.currentWebpage
    }
    
    var navigationError: NSError?
    
    private var urlHost: String?
    
    private var urlObserver: NSKeyValueObservation?
    private var progressObserver: NSKeyValueObservation?
    private var themeColorObserver: NSKeyValueObservation?
    private var underPageColorObserver: NSKeyValueObservation?
    private var canGoBackObserver: NSKeyValueObservation?
    private var canGoForwardObserver: NSKeyValueObservation?
    
    weak var delegate: OLDTabViewControllerDelegate?
//    weak var superDelegate: S
    weak var controller: ViewController?
    
    ///// ?????? maybe remove alpha and transform to separate method
    init(isHidden: Bool, with filterListModel: FilterListModel) {
        self.filterListModel = filterListModel
        super.init(nibName: nil, bundle: nil)
        self.view.alpha = isHidden ? 0 : 1
        self.view.transform = isHidden ? CGAffineTransform(scaleX: 0.8, y: 0.8) : .identity
        isHidden ? nil : startBackForwardStackObserve()
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
        navigationError = nil
        tabModel.createWebpage(with: url)
        let webView = tabView.webView
        webView.load(URLRequest(url: url))
        hasLoadedURl = true
        hideFavoritesViewIfNedded()
        delegate?.activateToolbar()
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
    
//    func contentModeForNextWebPage() -> WKWebpagePreferences.ContentMode {
//        tabModel.setContentModeForNextWebpage()
//    }
    
    func reload() {
//        tabView.webView.reload()
    }
    func goBack() {
//        tabModel.goBack()
    }
    
    func goForward() {
//        tabModel.goForward()
    }
    
    func backForwardButtonStatus() -> (canGoBack: Bool, canGoForward: Bool) {
        return (tabModel.canGoBack, tabModel.canGoForward)
    }
    
    func addBookmark(with domain: String) {
//        favoritesModel.saveBookmark(with: domain)
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

private extension PortraitTabController {
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
    }
    
    func startURLObserve() {
        urlObserver = tabView.webView.observe(\WKWebView.url, options: .new) { _, _ in
            guard let url = self.tabView.webView.url else { return }
            self.delegate?.tabViewController(self, didStartLoadingURL: url)
            self.delegate?.heartButtonEnabled() // it should not be here🥸🥸🥸
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
}

@objc private extension PortraitTabController {
    func backForwardStackHasChanged() {
        delegate?.backForwardListHasChanged(
            tabModel.canGoBack,
            tabModel.canGoForward
        )
    }
    
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

extension PortraitTabController: WKNavigationDelegate {
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
                updateWebViewConfiguration(with: .mobile)
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
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard
            let response = navigationResponse.response as? HTTPURLResponse,
            (200..<300).contains(response.statusCode) else {
            tabView.pageloadedWithError = true
            decisionHandler(.allow)
            return
        }
        tabView.pageloadedWithError = false
        decisionHandler(.allow)
    }
    
    func loadHTMLWebpage(for url: URL, with error: NSError?) {
        let htmlString = HTML.webpageWith(error)
        tabView.webView.loadHTMLString(htmlString, baseURL: url)
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation, withError error: Error) {
        tabView.pageloadedWithError = true
        navigationError = error as NSError
        guard let url = loadingWebpage?.url else { return }
        loadHTMLWebpage(for: url, with: navigationError)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation) {
        tabModel.updateCurrentWebpage(error: navigationError)
    }
}

extension PortraitTabController: FavoritesViewDelegate {
    func hideKeyboard() {
        delegate?.hideKeyboard()
    }
    
    func deleteSelectedCells() {
        guard let indexPaths = favoritesView.collectionView.indexPathsForSelectedItems else { return }
        favoritesModel.deleteBookmark(at: indexPaths)
        favoritesView.collectionViewDeleteCells(at: indexPaths)
    }
    
    func collectionViewDidScroll() {
        delegate?.hideKeyboard()
    }
    
    func hideFavoritesViewIfNedded() {
        guard hasLoadedURl else { return }
        tabView.hideFavoritesView()
        updateStatusBarColor()
    }
}
