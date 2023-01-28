//
//  WebpagesBackForwardStack.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 30.01.2023.
//

import Foundation

final class WebpagesBackForwardStack {
    private lazy var backStack = WebpagesStack()
    private lazy var forwardStack = WebpagesStack()
    
    var backWebpages: [Webpage] {
        backStack.webpages
    }
    
    var forwardWebpages: [Webpage] {
        forwardStack.webpages
    }
    
    func goBackWebpage() {
        guard let forwardWebpage = currentWebpage else { return }
        currentWebpage = nil
        forwardStack.push(webpage: forwardWebpage)
        currentWebpage = backStack.popWebpage()
    }
    
    func goForwardWebpage() {
        guard let backWebpage = currentWebpage else { return }
        currentWebpage = nil
        backStack.push(webpage: backWebpage)
        currentWebpage = forwardStack.popWebpage()
    }
    
    var canGoBack: Bool {
        !backStack.isEmpty
    }
    var canGoForward: Bool {
        !forwardStack.isEmpty
    }
    
    var currentWebpage: Webpage? {
        willSet {
            guard
                let currentWebpage,
                newValue != nil,
                newValue?.url != currentWebpage.url else { return }
            backStack.push(webpage: currentWebpage)
            forwardStack.empty()
        }
    }
}

private class WebpagesStack {
    private let notificationCenter = NotificationCenter.default
    private var container: [Webpage] = [] {
        didSet {
            notificationCenter.post(name: .backForwardStackChanged, object: nil)
        }
    }
    
    var webpages: [Webpage] {
        container
    }
    
    func count() -> Int {
        container.count
    }
    
    var isEmpty: Bool {
        container.isEmpty
    }
    
    func lastItem() -> Webpage? {
        container.last
    }
    
    func push(webpage: Webpage) {
        container.append(webpage)
    }
    
    func popWebpage() -> Webpage? {
        container.removeLast()
    }
    
    func empty() {
        container = []
    }
}
