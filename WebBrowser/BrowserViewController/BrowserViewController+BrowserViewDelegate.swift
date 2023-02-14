//
//  BrowserViewController+BrowserViewDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 14.02.2023.
//

import UIKit

extension BrowserViewController: BrowserViewDelegate {
    func goBackButtonTapped() {
        guard let tabViewController = tabViewControllers[safe: currentTabIndex] else { return }
        tabViewController.goBack()
        let contentMode = tabViewController.contentModeForNextWebPage()
        currentAddressBar.updateAaButtonMenuFor(contentMode: contentMode)
    }
    
    func goForwardButtontTapped() {
        guard let tabViewController = tabViewControllers[safe: currentTabIndex] else { return }
        tabViewController.goForward()
        let contentMode = tabViewController.contentModeForNextWebPage()
        currentAddressBar.updateAaButtonMenuFor(contentMode: contentMode)
    }
    
    func heartButtonTapped() {
        let currentWebpage = currentTabController.currentWebPage
        currentTabController.addBookmark(with: currentWebpage)
    }
    
    func addTabButtonTapped() {
        addTabViewController()
        currentTabIndex += 1
    }
    
    func plusButtonTapped() {
        browserView.showDialogBox()
    }
    
    func listButtonTapped() {
        let viewController = FilterListViewController(filterListModel: filterListModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true)
    }
    
    @objc func dialogBoxAddFilterButtonTapped() {
        guard let filter = browserView.dialogBox?.textField.text else { return }
        filterListModel.filters.insert(filter)
        browserView.dialogBox?.endEditing(true)
    }
    
    @objc func cancelButtonTapped() {
        browserView.dialogBox?.endEditing(true)
    }
}
