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
}

class TabViewController: UIViewController {
    private lazy var tabView = TabView()
    lazy var hasLoadedURl = false
    lazy var startYOffset: CGFloat = 0.0
    
    weak var delegate: TabViewControllerDelegate?
    
    init(isHidden: Bool) {
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
    
    override func observeValue(
        forKeyPath keyPath: String?,
        of object: Any?,
        change: [NSKeyValueChangeKey: Any]?,
        context: UnsafeMutableRawPointer?
    ) {
        switch keyPath {
        case #keyPath(WKWebView.url):
            guard let url = tabView.webView.url else { return }
            delegate?.tabViewController(self, didStartLoadingURL: url)
        case #keyPath(WKWebView.estimatedProgress):
            let progress = tabView.webView.estimatedProgress
            delegate?.tabViewController(self, didChangeLoadingProgressTo: Float(progress))
        default:
            break
        }
        
        if #available(iOS 15.0, *) {
            switch keyPath {
            case
                #keyPath(WKWebView.themeColor),
                #keyPath(WKWebView.underPageBackgroundColor):
                updateStatusBarColor()
            default:
                break
            }
        }
    }
    
    func loadWebsite(from url: URL) {
        tabView.webView.load(URLRequest(url: url))
        hasLoadedURl = true
        hideEmptyStateIfNedded()
    }
    
    func showEmptyState() {
        tabView.showEmptyStateView()
    }
    
    func hideEmptyStateIfNedded() {
        guard hasLoadedURl else { return }
        tabView.hideEmptyStateView()
    }
}

private extension TabViewController {
    func setupWebView() {
        tabView.webView.scrollView.panGestureRecognizer.addTarget(self, action: #selector(handlePan(_:)))
        tabView.webView.addObserver(
            self, forKeyPath: #keyPath(WKWebView.url), options: .new, context: nil
        )
        tabView.webView.addObserver(
            self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil
        )
        if #available(iOS 15.0, *) {
            tabView.webView.addObserver(
                self, forKeyPath: #keyPath(WKWebView.themeColor), options: .new, context: nil
            )
            tabView.webView.addObserver(
                self, forKeyPath: #keyPath(WKWebView.underPageBackgroundColor), options: .new, context: nil
            )
        }
    }
    
    func updateStatusBarColor() {
        guard #available(iOS 15.0, *) else { return }
        let color = tabView.webView.themeColor ?? tabView.webView.underPageBackgroundColor ?? .red
        tabView.statusBarBackgroundView.setColor(color)
        setNeedsStatusBarAppearanceUpdate()
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
