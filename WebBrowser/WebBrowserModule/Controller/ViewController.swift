//
//  ViewController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit
import WebKit

final class ViewController: UIViewController {
    lazy var webBrowserView: WebBrowserView = {
        let view = WebBrowserView()
        view.delegate = self
        return view
    }()
    lazy var filterListModel = FilterListModel()
    lazy var webBrowserModel = WebBrowserModel()
    lazy var hasHiddenTab = false
    lazy var isCollapsed = false
    lazy var toolbarIsHide = false
    lazy var isAddressBarActive = false
    lazy var currentTabIndex = 0 {
        didSet {
            updateAddressBarsAfterTabChange()
            updateToolbarButtons()
        }
    }
    
    var collapsingToolbarAnimator: UIViewPropertyAnimator?
    var expandingToolbarAnimator: UIViewPropertyAnimator?
    
    lazy var tabViewControllers: [TabViewController] = []
    
    var currentAddressBar: AddressBar {
        webBrowserView.addressBars[currentTabIndex]
    }
    
    var leftAddressBar: AddressBar? {
        webBrowserView.addressBars[safe: currentTabIndex - 1]
    }
    
    var rightAddressBar: AddressBar? {
        webBrowserView.addressBars[safe: currentTabIndex + 1]
    }
    
    override var childForStatusBarStyle: UIViewController? {
        tabViewControllers[safe: currentTabIndex]
    }
    
    override func loadView() {
        super.loadView()
        self.view = webBrowserView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        print(path)
        setupAddressBarScrollView()
        setupKeyboardManager()
        openNewTab(isHidden: false)
        setupAddressBarExpandingTap()
    }
    
    func backForwardListHasChanged(_ canGoBack: Bool, _ canGoForward: Bool) {
        let backForwardButtonStatus = (canGoBack, canGoForward)
        webBrowserView.enableToolbarButtons(with: backForwardButtonStatus)
    }
    
    func hostHasChanged() { // MAYBE change place for that method
        currentAddressBar.updateAaButtonMenuFor(contentMode: .mobile)
    }
    
    func heartButtonEnabled() {
        webBrowserView.toolbar.heartButton.isEnabled = true
    }

    func hideKeyboard() {
        dismissKeyboard()
        print("KEYBOARD")
    }
}

private extension ViewController {
    func setupAddressBarScrollView() {
        webBrowserView.addressBarScrollView.delegate = self
    }
    
    func openNewTab(isHidden: Bool) {
        hasHiddenTab = isHidden
        addTabViewController(isHidden: isHidden)
        webBrowserView.addAddressBar(isHidden: isHidden, withDelegate: self)
    }
    
    func openNewTabIfNeeded(tabViewController: TabViewController) {
        let isLastTab = currentTabIndex == tabViewControllers.count - 1
        if isLastTab, !tabViewController.hasLoadedURl {
            openNewTab(isHidden: true)
        }
    }
    
    func updateWebpageContentModeFor(_ tabViewController: TabViewController, and url: URL) {
        if tabViewController.hasURLHostChanged(in: url) {
            currentAddressBar.updateAaButtonMenuFor(contentMode: .mobile)
            tabViewController.updateWebpagePreferences(with: .mobile)
        }
    }
    
    func addTabViewController(isHidden: Bool) {
        let tabViewController = TabViewController(isHidden: isHidden, with: filterListModel)
        tabViewController.delegate = self
        tabViewControllers.append(tabViewController)
        addChild(tabViewController)
        tabViewController.didMove(toParent: self)
        webBrowserView.addToTabsStackView(tabViewController.view)
    }
    
    func updateAddressBarsAfterTabChange() {
        currentAddressBar.isUserInteractionEnabled = true
        currentAddressBar.setSideButtonsHiden(false)
        leftAddressBar?.isUserInteractionEnabled = false
        leftAddressBar?.setSideButtonsHiden(true)
        rightAddressBar?.isUserInteractionEnabled = false
        rightAddressBar?.setSideButtonsHiden(true)
    }
    
    func updateToolbarButtons() {
        guard let tabViewController = tabViewControllers[safe: currentTabIndex] else { return }
        let backForwardButtonStatus = tabViewController.backForwardButtonStatus()
        webBrowserView.enableToolbarButtons(with: backForwardButtonStatus)
    }
    
    func setupAddressBarExpandingTap() {
        let tapGestureRecogniser = UITapGestureRecognizer(
            target: self,
            action: #selector(addressBarTapped)
        )
        currentAddressBar.addGestureRecognizer(tapGestureRecogniser)
    }
}

@objc private extension ViewController {
    func cancelButtonTapped() {
        dismissKeyboard()
    }
    
    func addressBarTapped() {
        toolbarIsHide = false
        activateToolbar()
    }
}

extension ViewController { // TabViewControllerDelegate🥸🥸🥸
    func tabViewController(
        _ tabViewController: TabViewController,
        selected bookmark: Bookmark
    ) {
        openNewTabIfNeeded(tabViewController: tabViewController)
        updateWebpageContentModeFor(tabViewController, and: bookmark.url)
        tabViewController.loadWebsite(from: bookmark.url)
        let text = bookmark.url.absoluteString
        currentAddressBar.updateAfterLoadingBookmark(text: text)
        dismissKeyboard()
    }
}

extension ViewController: AddressBarDelegate {
    func addressBarWillBeginEditing(_ addressBar: AddressBar) {
        guard let tabViewController = tabViewControllers[safe: currentTabIndex] else {
            return
        }
        if
            tabViewController.hasLoadedURl,
            let urlString = tabViewController.currentURL?.absoluteString {
            addressBar.textField.text = urlString
        }
    }
    
    func addressBarDidBeginEditing() {
        isAddressBarActive = true
    }
    
    func addressBar(_ addressBar: AddressBar, didReturnWithText text: String) {
        let tabViewController = tabViewControllers[currentTabIndex]
        openNewTabIfNeeded(tabViewController: tabViewController)
        if let url = webBrowserModel.getURL(for: text) {
            updateWebpageContentModeFor(tabViewController, and: url)
            tabViewController.loadWebsite(from: url)
        }
        dismissKeyboard()
    }
    
    func aAButtonMenuWillShow() {
        webBrowserView.disableToolbarButtons()
    }
    
    func aAButtonMenuWillHide() {
        updateToolbarButtons()
    }
    
    func reloadCurrentWebpage() {
        let tabViewController = tabViewControllers[safe: currentTabIndex]
        tabViewController?.reload()
        tabViewController?.hideFavoritesViewIfNedded()
    }
    
    func requestWebpageWith(contentMode: WKWebpagePreferences.ContentMode ) {
        let tabViewController = tabViewControllers[safe: currentTabIndex]
        tabViewController?.updateWebpagePreferences(with: contentMode)
    }
    
    func hideToolbar() {
        toolbarIsHide = true
        deactivateToolbar()
    }
}

extension ViewController: WebBrowserViewDelegate {
    func goBackButtonTapped() {
        guard let tabViewController = tabViewControllers[safe: currentTabIndex] else { return }
        let contentMode = tabViewController.getBackItemContentMode()
        currentAddressBar.updateAaButtonMenuFor(contentMode: contentMode)
        tabViewController.goBack()
    }
    
    func goForwardButtontTapped() {
        guard let tabViewController = tabViewControllers[safe: currentTabIndex] else { return }
        let contentMode = tabViewController.getForwardItemContentMode()
        currentAddressBar.updateAaButtonMenuFor(contentMode: contentMode)
        tabViewController.goForward()
    }
    
    func heartButtonTapped() {
        guard let tabViewController = tabViewControllers[safe: currentTabIndex] else { return }
        let domain = currentAddressBar.domainTitleString
        tabViewController.addBookmark(with: domain)
    }
    
    func plusButtonTapped() {
        webBrowserView.showDialogBox()
    }
    
    func listButtonTapped() {
        let viewController = FilterListViewController(filterListModel: filterListModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true)
    }
    
    func updateFilters(with filter: String) {
        filterListModel.filters.insert(filter)
    }
}
