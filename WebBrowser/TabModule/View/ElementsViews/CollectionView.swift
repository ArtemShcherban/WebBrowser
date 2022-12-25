//
//  CollectionView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 23.12.2022.
//

import UIKit

final class CollectionView: UICollectionView {
    override init(
        frame: CGRect,
        collectionViewLayout
        layout: UICollectionViewLayout
    ) {
        super.init(frame: frame, collectionViewLayout: UICollectionViewLayout())
        collectionViewLayout = setupCompositionalLayout()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CollectionView {
    func setupCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 4),
            heightDimension: .fractionalHeight(1)
        )
        let cell = NSCollectionLayoutItem(layoutSize: cellSize)
        cell.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        let cellGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1 / 6)
        )
        
        let cellGroup = NSCollectionLayoutGroup.horizontal(layoutSize: cellGroupSize, subitems: [cell])
        cellGroup.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: cellGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: -2, bottom: 0, trailing: -2)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1 / 20)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading)
        section.boundarySupplementaryItems = [sectionHeader]
        
        let collectionViewCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return collectionViewCompositionalLayout
    }
    
    func setupView() {
        register(
            CollectionViewCell.self,
            forCellWithReuseIdentifier: CollectionViewCell.reuseidentifier
        )
        register(
            FavoritesHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FavoritesHeaderView.reuseidentifier
        )
        self.showsHorizontalScrollIndicator = false
    }
}
