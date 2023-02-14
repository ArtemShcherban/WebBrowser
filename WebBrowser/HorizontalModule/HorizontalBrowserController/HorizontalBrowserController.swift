//
//  HorizontalBrowserController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit

class HorizontalBrowserController: BrowserViewController {
    let horizontalBrowserView = HorizontalBrowserView()
    
    init() {
        super.init(browserView: horizontalBrowserView)
        horizontalBrowserView.controller = self
    }
    
    override func loadView() {
        super.loadView()
        self.view = horizontalBrowserView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        horizontalBrowserView.addAddressBar()
        addTabViewController()
    }
    
    override func addTabViewController(isHidden: Bool = false) {
        super.addTabViewController(isHidden: isHidden)
        guard let lastTabController = tabViewControllers.last as? HorizontalTabController else { return }
        horizontalBrowserView.addСontentOf(lastTabController.tabView)
    }
    
    override func updateAddressBarAfterTabChange() {
        let url = currentTabController.tabView.webView.url
        currentAddressBar.textField.text = url?.absoluteString
        currentAddressBar.domainTitleString = browserModel.getDomain(from: url)
        currentAddressBar.textField.activityState = .inactive
        super.updateAddressBarAfterTabChange()
    }
}
