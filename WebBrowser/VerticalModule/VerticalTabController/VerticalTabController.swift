//
//  VerticalTabController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit
import WebKit

class VerticalTabController: TabViewController {
    private var verticalTabView = VerticalTabView(favoritesModel: FavoritesModel())
    
    lazy var startYOffset: CGFloat = 0.0

    private var themeColorObserver: NSKeyValueObservation?
    
    private var underPageColorObserver: NSKeyValueObservation?
    private var canGoBackObserver: NSKeyValueObservation?
    private var canGoForwardObserver: NSKeyValueObservation?
    
    weak var delegate: OLDTabViewControllerDelegate?
    
    init(isHidden: Bool, with filterListModel: FilterListModel) {
        super.init(
            tabView: verticalTabView,
            filterListModel: filterListModel,
            favoritesModel: verticalTabView.favoritesView.favoritesModel
        )
        setupInitialAppearance(isHidden)
        self.showFavoritesView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = tabView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupWebView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        let isBackgroundColorDark = verticalTabView.statusBarBackgroundView.backgroundColor?.isDark ?? false
        return isBackgroundColorDark ? .lightContent : .darkContent
    }
    
    override func startWebViewObserve() {
        super.startWebViewObserve()
        startThemeColorObserve()
        startUnderPageColorObserve()
    }
    
    override func showFavoritesView() {
        super.showFavoritesView()
        updateStatusBarColor()
    }
    
    func removeBackForwardStackObserve() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: .backForwardStackChanged, object: nil)
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

extension VerticalTabController {
    private func setupInitialAppearance(_ isHidden: Bool) {
        self.view.alpha = isHidden ? 0 : 1
        self.view.transform = isHidden ? CGAffineTransform(scaleX: 0.8, y: 0.8) : .identity
        isHidden ? nil : startBackForwardStackObserve()
    }
    
//    private func setupWebView() {
//        tabView.webView.scrollView.panGestureRecognizer.addTarget(
//            self,
//            action: #selector(handlePan(_:))
//        )
//        tabView.webView.navigationDelegate = self
//    }
    
    private func startThemeColorObserve() {
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
        verticalTabView.statusBarBackgroundView.setColor(color)
        setNeedsStatusBarAppearanceUpdate()
    }
}
