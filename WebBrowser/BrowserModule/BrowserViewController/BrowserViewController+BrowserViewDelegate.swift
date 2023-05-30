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
        let contentMode = currentTabController.contentMode
        currentAddressBar.updateAaButtonMenuFor(contentMode: contentMode)
    }
    
    func goForwardButtontTapped() {
        currentTabController.go(.forward)
        let contentMode = currentTabController.contentMode
        currentAddressBar.updateAaButtonMenuFor(contentMode: contentMode)
    }
    
    func heartButtonTapped() {
        currentTabController.addBookmark()
    }
    
    func addTabButtonTapped() {
        addTabViewController()
        currentTabIndex = tabViewControllers.count - 1
        NotificationCenter.default.post(name: .tabViewControllerHasAdded, object: nil)
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
