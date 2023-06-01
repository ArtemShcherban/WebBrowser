//
//  HeadlinesCollectionView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.03.2023.
//

import UIKit

class HeadlinesCollectionView: UICollectionView {
    private let headlinesLayout = HeadlinesCollectionViewFlowLayout()
    let dublicateLayot = DublicateLayout()
    
    init() {
        super.init(frame: .zero, collectionViewLayout: headlinesLayout)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveContentIfNedeed() {
        if numberOfItems(inSection: 0) > 7 {
            collectionViewLayout = dublicateLayot
            layoutIfNeeded()
            UIView.animate(
                withDuration: 0,
                delay: 0,
                options: .curveEaseInOut
            ) {
                self.setContentOffset(
                    CGPoint(
                        x: self.contentSize.width - self.bounds.width,
                        y: 0
                    ),
                    animated: true)
            } completion: { _ in
                self.collectionViewLayout = self.headlinesLayout
            }
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
