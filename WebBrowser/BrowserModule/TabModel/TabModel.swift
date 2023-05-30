//
//  TabModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 20.12.2022.
//

import UIKit
import WebKit
import RxSwift

class TabModel {
    private let webView: WKWebView
    private lazy var webpageBackForwardStack = WebpagesBackForwardStack()
    private lazy var networkService = IconNetworkService()
    private var disposeBag = DisposeBag()
    private var subscription = Disposables.create()

    var canGoBack: Bool { !webpageBackForwardStack.backWebpages.isEmpty }
    var canGoForward: Bool { !webpageBackForwardStack.frontWebpages.isEmpty }
    var backWebpage: Webpage? { webpageBackForwardStack.backWebpages.last }
    var frontWebpage: Webpage? { webpageBackForwardStack.frontWebpages.last }
    
    var currentWebpage: Observable<Webpage?> {
        webpageBackForwardStack.observableWebpage
    }
    
    init(webView: WKWebView) {
        self.webView = webView
    }
    
    func updateCurrentWebpage(error: NSError?) {
        currentWebpage
            .map { webpage -> Void in
                webpage?.title = self.webView.title
                webpage?.mainTitle.onNext(self.webView.title)
                webpage?.error = error
                webpage?.contentMode.accept(
                    self.webView.configuration.defaultWebpagePreferences.preferredContentMode
                )
            }
            .subscribe()
            .dispose()
    }
    
    func updateBackForwardStackAfterMoving(_ direction: Direction) {
        webpageBackForwardStack.move(to: direction)
    }
    
    func createWebpage(with url: URL, _ hasHostChanged: Bool) {
        subscription.dispose()
        let contentMode = webView.configuration.defaultWebpagePreferences.preferredContentMode
        let webpage = Webpage(
            url: url,
            mainTitle: "Loading ...",
            favoriteIcon: hasHostChanged == false ? networkService.favoriteIconRelay.value : UIImage(),
            contentMode: contentMode
        )
        
        subscription = networkService.favoriteIconRelay
            .skip(1)
            .subscribe { favoriteIcon in
                webpage.favoriteIcon.onNext(favoriteIcon)
            }
            
        if hasHostChanged {
            do {
                try networkService.loadIconData(with: url)
            } catch let error {
                if let error = error as? NetworkServiceError {
                    print(error.rawValue)
                }
            }
        }
        webpageBackForwardStack.currentWebpageChanged(webpage)
    }
    
    func createStartPage(count: Int) {
        let contentMode: WKWebpagePreferences.ContentMode = .recommended
        let scaleConfiguration = UIImage.SymbolConfiguration(scale: .small)
        let startPage = Webpage(
            url: nil,
            title: nil,
            mainTitle: "Start page \(count)",
            favoriteIcon: UIImage(systemName: "star.fill", withConfiguration: scaleConfiguration),
            error: nil,
            contentMode: contentMode
        )
        webpageBackForwardStack.currentWebpageChanged(startPage)
    }
}
