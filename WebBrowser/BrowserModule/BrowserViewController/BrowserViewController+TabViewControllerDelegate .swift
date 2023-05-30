//
//  BrowserViewController+TabViewControllerDelegate .swift
//  WebBrowser
//
//  Created by Artem Shcherban on 13.02.2023.
//

import UIKit

extension BrowserViewController: TabViewControllerDelegate {
    @objc func tabViewControllerDidScroll(yOffsetChange: CGFloat) { }
    
    @objc func tabViewControllerDidEndDraging(yOffsetChange: CGFloat = 0.0) { }
    
    func tabViewController(_ tabViewController: TabViewController, didStartLoadingURL url: URL) {
        guard
            let tabIndex = tabIndex(for: tabViewController),
            let addressBar = browserView.addressBars[safe: tabIndex] else {
            return
        }
        addressBar.setLoadingProgress(0, animated: false)
        addressBar.domainTitleString = browserModel.getDomain(from: url)
    }
    
    func tabViewController(_ tabViewController: TabViewController, didChangeLoadingProgressTo progress: Float) {
        guard
            let tabIndex = tabIndex(for: tabViewController),
            let addressBar = browserView.addressBars[safe: tabIndex] else {
            return
        }
        addressBar.setLoadingProgress(progress, animated: true)
    }
    
    @objc func bookmarkHasTapped(_ tabViewController: TabViewController, _ bookmark: Bookmark) {
        updateWebpageContentModeFor(tabViewController, and: bookmark.url)
        tabViewController.loadWebsite(from: bookmark.url)
        let text = bookmark.url.absoluteString
        currentAddressBar.updateAfterLoadingBookmark(text: text)
        dismissKeyboard()
    }
    
    func hostHasChanged() {
        currentAddressBar.updateAaButtonMenuFor(contentMode: .mobile)
    }
    
    func backForwardListHasChanged(_ canGoBack: Bool, _ canGoForward: Bool) {
        let backForwardButtonStatus = (canGoBack, canGoForward)
        browserView.enableToolbarButtons(
            with: backForwardButtonStatus,
            and: currentTabController.hasLoadedURl
        )
    }
    
    func heartButtonEnabled(_ isEnabled: Bool) {
        browserView.toolbar.heartButton.isEnabled = isEnabled
    }
    
    func activateToolbar() {
        guard isCollapsed && toolbarIsHide == false else { return }
        setupExpandingToolbarAnimator()
        expandingToolbarAnimator?.startAnimation()
        isCollapsed = false
        currentAddressBar.updateProgressView(addressBar: isCollapsed)
        currentAddressBar.isUserInteractionEnabled = true
    }
    
    func hideKeyboard() {
        dismissKeyboard()
    }
}

private extension BrowserViewController {
    private func tabIndex(for tabViewController: TabViewController) -> Int? {
        if Interface.orientation == .portrait {
            return tabViewControllers.firstIndex(of: tabViewController)
        } else {
            return  0
        }
    }
}

extension BrowserViewController {
    @objc func setupCollapsingToolbarAnimator() { }
    @objc func setupExpandingToolbarAnimator() { }
}
