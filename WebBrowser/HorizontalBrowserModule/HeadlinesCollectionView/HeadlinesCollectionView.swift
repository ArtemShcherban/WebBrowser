//
//  HeadlinesCollectionView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.03.2023.
//

import UIKit

class HeadlinesCollectionView: UICollectionView {
    private let headlinesLayout = HeadlinesCollectionViewFlowLayout()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: headlinesLayout)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveContentIfNedeed() {
        if numberOfItems(inSection: 0) > 7 {
            setContentOffset(
                CGPoint(x: headlinesLayout.collectionViewContentSize.width - bounds.width, y: 0),
                animated: true)
        }
    }
}

private extension HeadlinesCollectionView {
    func setupView() {
        register(HeadlineCell.self, forCellWithReuseIdentifier: HeadlineCell.reuseIdentifier)
        showsHorizontalScrollIndicator = false
        contentInsetAdjustmentBehavior = .never
        isDirectionalLockEnabled = true
        isScrollEnabled = true
    }
}

@objc private extension HeadlinesCollectionView {
    func tabsHeadlinesHaveChanged() {
        DispatchQueue.main.async {
            self.reloadData()
        }
    }
}
