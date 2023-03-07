//
//  BookmarksCollectionView+CompositionalLayouts.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 04.03.2023.
//

import UIKit

extension BookmarksCollectionView {
    func chooseCompositionalLayout() {
        if
            traitCollection.horizontalSizeClass == .compact && traitCollection.verticalSizeClass == .regular {
            collectionViewLayout = setupVerticalCompositionalLayout()
        } else if
            traitCollection.horizontalSizeClass == .regular ||
                (traitCollection.verticalSizeClass == .compact && traitCollection.horizontalSizeClass == .compact) {
            collectionViewLayout = setupHorizontalCompositionalLayout()
        }
    }
    
    func updateAnimation() {
        self.indexPathsForVisibleItems.forEach { indexPath in
            guard let cell = self.cellForItem(at: indexPath) as? EditingBookmarkCell
            else {
                return
            }
            cell.animateAppearance()
        }
    }
    
    func setupVerticalCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let groupFractionalHeight = Interface.screenHeight > 750 ? (1 / 5.4) : (1 / 4.6)
        let cellSideInset = Interface.screenHeight > 750 ? 12.0 : 14.0
        
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 4),
            heightDimension: .fractionalHeight(1.0)
        )
        let cell = NSCollectionLayoutItem(layoutSize: cellSize)
        cell.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: cellSideInset, bottom: 0, trailing: cellSideInset
        )
        
        let cellGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(groupFractionalHeight)
        )
        
        let cellGroup = NSCollectionLayoutGroup.horizontal(layoutSize: cellGroupSize, subitems: [cell])
        cellGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: cellGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40.0)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        let verticalCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return verticalCompositionalLayout
    }
    
    func setupHorizontalCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let cellSideInset: CGFloat
        let groupSideInset: CGFloat
        if traitCollection.horizontalSizeClass == .compact &&
            traitCollection.verticalSizeClass == .compact {
            cellSideInset = 22
            groupSideInset = 0
        } else {
            cellSideInset = 16
            groupSideInset = 72
        }
        
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 6),
            heightDimension: .fractionalHeight(1.0)
        )
        let cell = NSCollectionLayoutItem(layoutSize: cellSize)
        cell.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: cellSideInset, bottom: 0, trailing: cellSideInset)
        
        let cellGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1 / 2.7)
        )
        
        let cellGroup = NSCollectionLayoutGroup.horizontal(layoutSize: cellGroupSize, subitems: [cell])
        cellGroup.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: groupSideInset, bottom: 0, trailing: groupSideInset
        )

        let section = NSCollectionLayoutSection(group: cellGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(47.0)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        let horizontalCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return horizontalCompositionalLayout
    }
    
    func setupMiniCompositionalLayout() -> UICollectionViewLayout {
        let cellsInRow: CGFloat
        let cellSideInset: CGFloat
        let cellBottomInset: CGFloat
        if traitCollection.horizontalSizeClass == .compact &&
            traitCollection.verticalSizeClass == .compact {
            cellsInRow = 4
            cellSideInset = 24
            cellBottomInset = 2
        } else {
            cellsInRow = 6
            cellSideInset = 10
            cellBottomInset = 10
        }
        
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / cellsInRow),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let cell = NSCollectionLayoutItem(layoutSize: cellSize)
        cell.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: cellSideInset, bottom: cellBottomInset, trailing: cellSideInset
        )
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1 / 2.22)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [cell])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(40.0)
        )
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .topLeading
        )
        section.boundarySupplementaryItems = [sectionHeader]
        
        let miniCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return miniCompositionalLayout
    }
}
