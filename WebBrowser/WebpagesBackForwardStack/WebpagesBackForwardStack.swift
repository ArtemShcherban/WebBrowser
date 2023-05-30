//
//  WebpagesBackForwardStack.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 30.01.2023.
//

import Foundation
import RxSwift
import RxRelay

final class WebpagesBackForwardStack {
    private lazy var backStack = WebpagesStack()
    private lazy var forwardStack = WebpagesStack()
    
    private let disposeBag = DisposeBag()
    let currentWebpageRelay = BehaviorRelay<Webpage?>(value: nil)
    var observableWebpage: Observable<Webpage?> {
        currentWebpageRelay
            .distinctUntilChanged()
            .asObservable()
    }
    
    func currentWebpageChanged(_ newWebpage: Webpage) {
        if
            let currentWebpage = currentWebpageRelay.value,
            currentWebpage.url != nil {
            backStack.push(webpage: currentWebpage)
        }
        currentWebpageRelay.accept(newWebpage)
        forwardStack.empty()
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
        guard let nextFrontWebpage = currentWebpageRelay.value else { return }
        forwardStack.push(webpage: nextFrontWebpage)
        currentWebpageRelay.accept(backStack.popWebpage())
    }
    
    func moveOneWebpageForward() {
        guard let nextBackWebpage = currentWebpageRelay.value else { return }
        backStack.push(webpage: nextBackWebpage)
        currentWebpageRelay.accept(forwardStack.popWebpage())
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
