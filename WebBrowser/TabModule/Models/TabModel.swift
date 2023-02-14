//
//  TabModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 20.12.2022.
//

import UIKit
import WebKit

protocol TabModelDelegate: AnyObject {
    var navigationError: NSError? { get set }
}

class TabModel {
    private let webView: WKWebView
    lazy var webpageBackForwardStack = WebpagesBackForwardStack()

    weak var delegate: TabModelDelegate?
    
    var currentWebpage: Webpage? {
        guard let webpage = webpageBackForwardStack.currentWebpage else { return nil }
        return webpage
    }
    
    init(webView: WKWebView, delegate: TabModelDelegate) {
        self.webView = webView
        self.delegate = delegate
    }
    
    func updateCurrentWebpage(error: NSError?) {
        webpageBackForwardStack.currentWebpage?.title = webView.title
        webpageBackForwardStack.currentWebpage?.error = error
        webpageBackForwardStack.currentWebpage?.contentMode =
        webView.configuration.defaultWebpagePreferences.preferredContentMode
    }
    
    func goBack() {
        webpageBackForwardStack.goBackWebpage()
        guard let url = currentWebpage?.url else { return }
        webView.load(URLRequest(url: url))
    }
    
    func goForward() {
        webpageBackForwardStack.goForwardWebpage()
        guard let url = currentWebpage?.url else { return }
        webView.load(URLRequest(url: url))
    }
    
    func setContentModeForNextWebpage() -> WKWebpagePreferences.ContentMode {
        guard let contentMode = currentWebpage?.contentMode else { return .mobile }
        webView.configuration.defaultWebpagePreferences.preferredContentMode = contentMode
        delegate?.navigationError = currentWebpage?.error
        return contentMode
    }
    
    func createWebpage(with url: URL, and error: NSError? = nil) {
        let contentMode = webView.configuration.defaultWebpagePreferences.preferredContentMode
        let webpage = Webpage(
            url: url,
            error: error,
            contentMode: contentMode
        )
        webpageBackForwardStack.currentWebpage = webpage
    }
}
