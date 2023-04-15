//
//  TabsCollectionView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.03.2023.
//

import UIKit

class TabsCollectionView: UICollectionView {
    weak var controller: HorizontalBrowserController?
    
    init() {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionViewLayout = setupCompositionalLayout()
        setupView()
        startTabsTitlesObserve()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func compositionalLayoutFor(_ cellCount: CGFloat) -> UICollectionViewCompositionalLayout {
        let cellCount = cellCount > 7 ? 8 : cellCount
        return  setupCompositionalLayout(for: cellCount)
    }
}

private extension TabsCollectionView {
    func setupCompositionalLayout(for cellCount: CGFloat = 1) -> UICollectionViewCompositionalLayout {
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / cellCount),
            heightDimension: .fractionalHeight(1.0)
        )
        let cell = NSCollectionLayoutItem(layoutSize: cellSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [cell])
 
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        
        let compositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return compositionalLayout
    }
    
    func setupView() {
        dataSource = TabsCollectionViewDataSource.shared
        register(TabCell.self, forCellWithReuseIdentifier: TabCell.reuseIdentifier)
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
    
    func startTabsTitlesObserve() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(tabsHeadlinesHaveChanged),
                name: .tabsHeadlinesHaveChanged,
                object: nil
            )
    }
}

@objc private extension TabsCollectionView {
    func tabsHeadlinesHaveChanged() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
