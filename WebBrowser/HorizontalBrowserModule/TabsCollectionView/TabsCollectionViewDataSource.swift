//
//  TabsCollectionViewDataSource.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.03.2023.
//

import UIKit

class TabsCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    static let shared = TabsCollectionViewDataSource()
   
    var tabsHeadlines: [Headline] = [] {
        didSet {
            NotificationCenter.default.post(name: .tabsHeadlinesHaveChanged, object: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tabsHeadlines.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let collectionView = collectionView as? TabsCollectionView,
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: TabCell.reuseIdentifier,
                for: indexPath) as? TabCell,
            let currentTabIndex = collectionView.controller?.currentTabIndex else {
            return UICollectionViewCell()
        }
        
        if currentTabIndex - 1 == indexPath.row {
            cell.isSideCell = true
        } else {
            cell.isSideCell = false
        }
        cell.isActive = currentTabIndex == indexPath.row
        cell.configure(with: tabsHeadlines[indexPath.row], isFavoriteIconVisible: tabsHeadlines.count < 6)
        
        cell.closeButtonTapped = {
            self.handleCloseButtonTapped(at: collectionView, and: indexPath)
        }
        return cell
    }
}

private extension TabsCollectionViewDataSource {
    func handleCloseButtonTapped(at collectionView: TabsCollectionView, and indexPath: IndexPath) {
        collectionView.controller?.deleteTabController(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        guard
            let currentTabIndex = collectionView.controller?.currentTabIndex,
            let activeCell = collectionView.cellForItem(
                at: IndexPath(row: currentTabIndex, section: 0)
            ) as? TabCell else { return }
        activeCell.isActive = true
        activeCell.setLogoVisibility(isFavoriteIconVisible: tabsHeadlines.count < 6)
        collectionView.visibleCells.forEach { cell in
            guard let cell = cell as? TabCell else { return }
            cell.setupRightBorder()
        }
        activeCell.closeButtonTapped = {
            self.handleCloseButtonTapped(at: collectionView, and: IndexPath(row: currentTabIndex, section: 0)
            )
        }
    }
}
