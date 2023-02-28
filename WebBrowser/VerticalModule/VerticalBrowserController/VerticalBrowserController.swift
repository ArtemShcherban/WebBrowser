//
//  VerticalBrowserController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit

class VerticalBrowserController: BrowserViewController {
    let verticalBrowserView = VerticalBrowserView()
   
    lazy var hasHiddenTab = false
    
    var leftAddressBar: AddressBar? {
        verticalBrowserView.addressBars[safe: currentTabIndex - 1]
    }
    
    var rightAddressBar: AddressBar? {
        verticalBrowserView.addressBars[safe: currentTabIndex + 1]
    }
    
    var leftTabViewController: VerticalTabController? {
    guard
        let tabViewController = tabViewControllers[safe: currentTabIndex - 1],
        let leftTabViewController = tabViewController as? VerticalTabController else { return nil }

        return leftTabViewController
    }
    
    var rightTabViewController: VerticalTabController? {
        guard
            let tabViewController = tabViewControllers[safe: currentTabIndex + 1],
            let rightTabViewController = tabViewController as? VerticalTabController else { return nil }

            return rightTabViewController
    }
    
    override var childForStatusBarStyle: UIViewController? {
        tabViewControllers[safe: currentTabIndex]
    }
    
    init() {
        super.init(browserView: verticalBrowserView)
        verticalBrowserView.controller = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = verticalBrowserView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        openNewTab(isHidden: false)
    }
    
    override func addTabViewController(isHidden: Bool) {
        super.addTabViewController(isHidden: isHidden)
        guard let lastTabController = tabViewControllers.last else { return }
        verticalBrowserView.addToTabsStackView(lastTabController.tabView)
    }
    
    override func updateAddressBarAfterTabChange() {
        currentAddressBar.isUserInteractionEnabled = true
        currentAddressBar.setSideButtonsHiden(false)
        currentTabController.startBackForwardStackObserve()
        updateSideAddressBarsAfterTabChange()
    }
    
    override func bookmarkWasSelected(_ tabViewController: TabViewController, selected: Bookmark) {
        guard let verticalTabController = tabViewController as? VerticalTabController else { return }
        openNewTabIfNeeded(tabViewController: verticalTabController)
        super.bookmarkWasSelected(tabViewController, selected: selected)
    }
    
    override func addressBar(_ addressBar: AddressBar, didReturnWithText: String) {
        guard let currentTabController = currentTabController as? VerticalTabController
        else { return }
        openNewTabIfNeeded(tabViewController: currentTabController)
        super.addressBar(addressBar, didReturnWithText: didReturnWithText)
    }
}

private extension VerticalBrowserController {
    func openNewTab(isHidden: Bool) {
        hasHiddenTab = isHidden
        addTabViewController(isHidden: isHidden)
        verticalBrowserView.addAddressBar(isHidden: isHidden)
    }
    
    func openNewTabIfNeeded(tabViewController: VerticalTabController) {
        let isLastTab = currentTabIndex == tabViewControllers.count - 1
        if isLastTab, !tabViewController.hasLoadedURl {
            openNewTab(isHidden: true)
        }
    }
    
    func updateSideAddressBarsAfterTabChange() {
        leftAddressBar?.isUserInteractionEnabled = false
        leftAddressBar?.setSideButtonsHiden(true)
        leftTabViewController?.removeBackForwardStackObserve()
        rightAddressBar?.isUserInteractionEnabled = false
        rightAddressBar?.setSideButtonsHiden(true)
        rightTabViewController?.removeBackForwardStackObserve()
    }
}
