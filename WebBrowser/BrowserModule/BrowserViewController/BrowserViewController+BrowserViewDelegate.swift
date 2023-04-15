//
//  BrowserViewController+BrowserViewDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 14.02.2023.
//

import UIKit

extension BrowserViewController: BrowserViewDelegate {
    func goBackButtonTapped() {
        currentTabController.go(.backward)
        let contentMode = currentTabController.currentWebpage?.contentMode ?? .mobile
        currentAddressBar.updateAaButtonMenuFor(contentMode: contentMode)
    }
    
    func goForwardButtontTapped() {
        currentTabController.go(.forward)
        let contentMode = currentTabController.currentWebpage?.contentMode ?? .mobile
        currentAddressBar.updateAaButtonMenuFor(contentMode: contentMode)
    }
    
    func heartButtonTapped() {
        guard let currentWebpage = currentTabController.currentWebpage else { return }
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
