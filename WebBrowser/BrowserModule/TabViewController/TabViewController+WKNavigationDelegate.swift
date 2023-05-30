//
//  TabViewController+WKNavigationDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 13.02.2023.
//

import UIKit
import WebKit

extension TabViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard var url = navigationAction.request.url else { return }
        switch navigationAction.navigationType {
        case .linkActivated:
            guard filterListModel.isAllowedURL(url) else {
                self.present(tabView.createPageBlockedDialogBox(), animated: true)
                decisionHandler(.cancel)
                return
            }
            if
                let query = url.query,
                !query.hasPrefix("sa=") {
                if let updatedURL = URL(string: query) {
                    url = updatedURL
                }
            }
            
            if hasHostChanged(in: url) || url.query != nil {
                updateWebViewConfiguration(with: .mobile)
                controller?.hostHasChanged()
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
