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
    private lazy var contentModes: [WKWebpagePreferences.ContentMode] = []
    private var backListCount: Int {
        webView.backForwardList.backList.count
    }
    private var backForwardListCount: Int {
        let fowardListCount = webView.backForwardList.forwardList.count
        return backListCount + fowardListCount + 1
    }
    
    init(webView: WKWebView) {
        self.webView = webView
    }

    func updateCurrentItemContentMode() {
        let currentItemIndex: Int
        let contentMode = webView.configuration.defaultWebpagePreferences.preferredContentMode
        
        if contentModes.isEmpty {
            currentItemIndex = 0
        } else if backListCount == 0 {
            currentItemIndex = 0
            contentModes.remove(at: currentItemIndex)
        } else if backListCount == contentModes.count {
            currentItemIndex = backListCount
        } else {
            currentItemIndex = backListCount
            contentModes.remove(at: currentItemIndex)
        }
        contentModes.insert(contentMode, at: currentItemIndex)
        if contentModes.count > backForwardListCount {
            contentModes.removeLast(contentModes.count - backListCount - 1)
        }
    }
    
    func getBackItemContentMode() -> WKWebpagePreferences.ContentMode {
        let backItemIndex = backListCount - 1
        let contentMode = contentModes[backItemIndex]
        webView.configuration.defaultWebpagePreferences.preferredContentMode = contentMode
        return contentMode
    }
    
    func getForwardItemContentMode() -> WKWebpagePreferences.ContentMode {
        let forwardItemIndex = backListCount + 1
        let contentMode = contentModes[forwardItemIndex]
        webView.configuration.defaultWebpagePreferences.preferredContentMode = contentMode
        return contentMode
    }
}
