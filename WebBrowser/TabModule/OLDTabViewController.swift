//
//  TabViewController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 09.02.2023.
//

import UIKit
import WebKit

//class TabViewController: UIViewController {
//    var tabView = MainTabView()
//    var favoritesView = MainFavoriteView()
//    
//    weak var delegate: TabViewControllerDelegate?
//    
//    private var urlObserver: NSKeyValueObservation?
//    private var progressObserver: NSKeyValueObservation?
//    
//    init() {
//        super.init(nibName: nil, bundle: nil)
//        startURLObserve()
//        startProgressObserve()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//    }
//}

//private extension TabViewController {
//    func startURLObserve() {
//        urlObserver = tabView.webView.observe(\WKWebView.url, options: .new) { _, _ in
//            guard let url = self.tabView.webView.url else { return }
//            self.delegate?.tabViewController(self, didStartLoadingURL: url)
//            self.delegate?.heartButtonEnabled() // it should not be here🥸🥸🥸
//        }
//    }
//    
//    func startProgressObserve() {
//        progressObserver = tabView.webView.observe(\WKWebView.estimatedProgress, options: .new) { _, _ in
//            let estimatedProgress = Float(self.tabView.webView.estimatedProgress)
//            self.delegate?.tabViewController(self, didChangeLoadingProgressTo: estimatedProgress)
//        }
//    }
//}
//
//class MainTabView: UIView {
//    var webView = WKWebView(frame: CGRect(
//        x: 0,
//        y: 0,
//        width: 0.1,
//        height: 0.1)
//    )
//}
//
//class MainFavoriteView: UIView { }
