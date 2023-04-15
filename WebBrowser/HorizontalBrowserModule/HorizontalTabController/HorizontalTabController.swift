//
//  HorizontalTabController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 13.02.2023.
//

import UIKit
import WebKit

class HorizontalTabController: TabViewController {
    private var horizontalTabView = HorizontalTabView()
    
    private var titleObserver: NSKeyValueObservation?
    
    init() {
        super.init(
            tabView: horizontalTabView
        )
        self.showFavoritesView()
        startBackForwardStackObserve()
        startTitleObserve()
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
    }
    
    override func showFavoritesView() {
        if hasLoadedURl && horizontalTabView.favoritesPopUpView == nil {
            horizontalTabView.showFavoritesPopUpView()
        } else if !hasLoadedURl {
            super.showFavoritesView()
        }
    }
}

private extension HorizontalTabController {
    func startTitleObserve() {
        titleObserver = tabView.webView.observe(\.title, options: .new) { webView, _ in
            guard
                let controller = self.controller as?  HorizontalBrowserController,
                let title = webView.title else { return }
            controller.tabController(self, hasChangedWebViewTitle: title)
        }
    }
}
