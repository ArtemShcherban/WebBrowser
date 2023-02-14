//
//  SuperTabView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit
import WebKit

class SuperTabView: UIView {
    private(set) var favoritesView: FavoritesView
    lazy var webView = WKWebView(
        frame: CGRect(
            x: 0,
            y: 0,
            width: 0.1,
            height: 0.1
        )
    )
    var startYOffset: CGFloat = 0.0
    
    var pageloadedWithError = false {
        didSet {
            webView.scrollView.isScrollEnabled = !pageloadedWithError
        }
    }
    
    weak var tabController: TabViewController?
    
    init(favoritesView: FavoritesView) {
        self.favoritesView = favoritesView
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showFavoritesView() {
        favoritesView.alpha = 1
    }
    
    func hideFavoritesView() {
        UIView.animate(withDuration: 0.2) {
            self.favoritesView.alpha = 0
        }
        if favoritesView.collectionView.isEditingMode {
            favoritesView.editingIsFinished()
        }
    }
    
    func setWebViewPanGestureRecignizer() {
        webView.scrollView.panGestureRecognizer.addTarget(
            self,
            action: #selector(handlePan(_:))
        )
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

private extension SuperTabView {
    func setupView() {
        backgroundColor = .white
        layer.masksToBounds = false
    }
    
    @objc func handlePan(_ panGestureRecognizer: UIPanGestureRecognizer) {
        var yOffset: CGFloat = 0.0
        
        if let collectionView = panGestureRecognizer.view as? BookmarksCollectionView {
            yOffset = collectionView.contentOffset.y
        } else {
            yOffset = webView.scrollView.contentOffset.y
        }
        
        switch panGestureRecognizer.state {
        case .began:
            startYOffset = yOffset
        case .changed:
            tabController?.controller?.tabViewControllerDidScroll(yOffsetChange: startYOffset - yOffset)
        case .failed, .cancelled, .ended:
            switch Interface.orientation {
            case .portrait:
                tabController?.controller?.tabViewControllerDidEndDraging()
            case .landscape:
                tabController?.controller?.tabViewControllerDidEndDraging(yOffsetChange: yOffset)
            }
        default:
            break
        }
    }
}
