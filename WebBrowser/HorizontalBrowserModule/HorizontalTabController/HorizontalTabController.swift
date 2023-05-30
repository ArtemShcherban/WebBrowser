//
//  HorizontalTabController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 13.02.2023.
//

import UIKit
import WebKit

final class HorizontalTabController: TabViewController {
    private var horizontalTabView = HorizontalTabView()
    
    init() {
        super.init(
            tabView: horizontalTabView
        )
        self.showFavoritesView()
        startBackForwardStackObserve()
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
