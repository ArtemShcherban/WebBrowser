//
//  WebpagesBackForwardStack.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 30.01.2023.
//

import Foundation

enum Direction {
    case backward
    case forward
}

final class WebpagesBackForwardStack {
    private lazy var backStack = WebpagesStack()
    private lazy var forwardStack = WebpagesStack()
    
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
    
    var backWebpages: [Webpage] {
        backStack.webpages
    }
    
    var frontWebpages: [Webpage] {
        forwardStack.webpages
    }
    
    func move(to direction: Direction) {
        switch direction {
        case .backward:
            moveOneWebpageBackward()
        case .forward:
            moveOneWebpageForward()
        }
    }
}

private extension WebpagesBackForwardStack {
    func moveOneWebpageBackward() {
        guard let nextFrontWebpage = currentWebpage else { return }
        currentWebpage = nil
        forwardStack.push(webpage: nextFrontWebpage)
        currentWebpage = backStack.popWebpage()
    }
    
    func moveOneWebpageForward() {
        guard let nextBackWebpage = currentWebpage else { return }
        currentWebpage = nil
        backStack.push(webpage: nextBackWebpage)
        currentWebpage = forwardStack.popWebpage()
    }
}

private class WebpagesStack {
    private let notificationCenter = NotificationCenter.default
    private var container: [Webpage] = [] {
        didSet {
            notificationCenter.post(name: .backForwardStackHasChanged, object: nil)
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
