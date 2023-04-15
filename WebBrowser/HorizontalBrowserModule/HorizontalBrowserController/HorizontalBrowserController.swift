//
//  HorizontalBrowserController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit

class HorizontalBrowserController: BrowserViewController {
    let horizontalBrowserView = HorizontalBrowserView()
    let tabsCollectionViewModel = TabsCollectionViewModel()
    
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
        horizontalBrowserView.tabsCollectionView.delegate = self
        horizontalBrowserView.tabsCollectionView.controller = self
        startTabViewControllerHasAddedObserve()
        horizontalBrowserView.addAddressBar()
        addTabViewController()
    }
    
    override func addTabViewController(isHidden: Bool = false) {
        if !tabViewControllers.isEmpty {
            currentTabController.removeBackForwardStackObserve()
        }
        super.addTabViewController(isHidden: isHidden)
        guard let lastTabController = tabViewControllers.last as? HorizontalTabController else { return }
        horizontalBrowserView.addСontentOf(lastTabController.tabView)
    }
    
    override func updateAddressBarAfterTabChange() {
        let url = currentTabController.tabView.webView.url
        currentAddressBar.textField.text = url?.absoluteString
        currentAddressBar.domainTitleString = browserModel.getDomain(from: url)
        currentAddressBar.textField.activityState = .inactive
    }
   
    // CHANGE LOCATION FOR THIS METHOD
    override func bookmarkHasTapped(_ tabViewController: TabViewController, _ bookmark: Bookmark) {
        tabsCollectionViewModel.getFavoriteIcon(for: currentTabIndex, andFor: bookmark.url)
        super.bookmarkHasTapped(tabViewController, bookmark)
    }
    
    func switchToTabControllerWith(index: Int) {
        currentTabController.removeBackForwardStackObserve()
        let newTabController = tabViewControllers[index]
        newTabController.startBackForwardStackObserve()
        horizontalBrowserView.addСontentOf(newTabController.tabView)
        currentTabIndex = index
        horizontalBrowserView.tabsCollectionView.reloadData()
    }
    
    func deleteTabController(at index: Int) {
        if (index == 0 || index == 1) && tabViewControllers.count == 2 {
            horizontalBrowserView.hideTabsCollectionView()
        } else {
            let cellCount = CGFloat(tabViewControllers.count - 1)
            horizontalBrowserView.showTabsCollectionViewWith(cellCount)
        }
        tabsCollectionViewModel.deleteTabTitle(at: index)
        tabViewControllers.remove(at: index)
        currentTabIndex = tabViewControllers.count == index ? tabViewControllers.count - 1 : index
        horizontalBrowserView.addСontentOf(currentTabController.tabView)
    }
    
    func tabController(_ tabController: TabViewController, hasChangedWebViewTitle title: String) {
        guard let index = tabViewControllers.firstIndex(of: tabController) else { return }
        tabsCollectionViewModel.changeHeadline(title: title, at: index)
    }
}

private extension HorizontalBrowserController {
    func startTabViewControllerHasAddedObserve() {
        let center = NotificationCenter.default
        center.addObserver(
            self, selector: #selector(tabViewControllerHasAdded), name: .tabViewControllerHasAdded, object: nil
        )
    }

    @objc func tabViewControllerHasAdded() {
        tabsCollectionViewModel.addStartPageHeadline()
        if tabViewControllers.count > 1 {
            let cellCount = CGFloat(tabViewControllers.count)
            horizontalBrowserView.showTabsCollectionViewWith(cellCount)
        }
    }
}

extension HorizontalBrowserController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switchToTabControllerWith(index: indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, canEditItemAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        true
    }
}
