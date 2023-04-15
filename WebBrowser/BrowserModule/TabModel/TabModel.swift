//
//  TabModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 20.12.2022.
//

import UIKit
import WebKit

class TabModel {
    private let webView: WKWebView
    private lazy var webpageBackForwardStack = WebpagesBackForwardStack()
    private lazy var networkService = NetworkService()

    var canGoBack: Bool { !webpageBackForwardStack.backWebpages.isEmpty }
    var canGoForward: Bool { !webpageBackForwardStack.frontWebpages.isEmpty }
    var backWebpage: Webpage? { webpageBackForwardStack.backWebpages.last }
    var frontWebpage: Webpage? { webpageBackForwardStack.frontWebpages.last }
    var currentWebpage: Webpage? {
        webpageBackForwardStack.currentWebpage
    }
    
    init(webView: WKWebView) {
        self.webView = webView
    }
    
    func updateCurrentWebpage(error: NSError?) {
        webpageBackForwardStack.currentWebpage?.title = webView.title
        webpageBackForwardStack.currentWebpage?.error = error
        webpageBackForwardStack.currentWebpage?.contentMode =
        webView.configuration.defaultWebpagePreferences.preferredContentMode
    }
    
    func updateBackForwardStackAfterMoving(_ direction: Direction) {
        webpageBackForwardStack.move(to: direction)
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
