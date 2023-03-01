//
//  BookmarksCollectionView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 23.12.2022.
//

import UIKit

enum CollectionViewType {
    case vertical
    case horizontal
    case mini
}

final class BookmarksCollectionView: UICollectionView {
    private let bookmarksDataSource = DataSource(favoritesModel: FavoritesModel())
    lazy var longPressGesture: UILongPressGestureRecognizer = {
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleLongPressGesture(_:))
        )
        longPressGesture.cancelsTouchesInView = true
        return longPressGesture
    }()
    
    var isEditingMode = false {
        didSet {
            if isEditingMode {
                addGestureRecognizer(longPressGesture)
            } else {
                removeGestureRecognizer(longPressGesture)
            }
        }
    }
    
    init(collectionViewType: CollectionViewType? = nil) {
        super.init(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        if collectionViewType == .mini {
            collectionViewLayout = setupMiniCompositionalLayout()
        } else {
            chooseCompositionalLayout()
        }
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func deleteCells(at indexPaths: [IndexPath]) {
        deleteItems(at: indexPaths)
        updateAnimation()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        guard
            traitCollection.verticalSizeClass != previousTraitCollection?.verticalSizeClass &&
                traitCollection.horizontalSizeClass != previousTraitCollection?.horizontalSizeClass else { return }
        chooseCompositionalLayout()
    }
}

private extension BookmarksCollectionView {
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
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 4),
            heightDimension: .fractionalHeight(1.0)
        )
        let cell = NSCollectionLayoutItem(layoutSize: cellSize)
        cell.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        let cellGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1 / 6)
        )
        
        let cellGroup = NSCollectionLayoutGroup.horizontal(layoutSize: cellGroupSize, subitems: [cell])
        cellGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
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
        
        let verticalCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return verticalCompositionalLayout
    }
    
    func setupHorizontalCompositionalLayout() -> UICollectionViewCompositionalLayout {
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 6),
            heightDimension: .fractionalHeight(1.0)
        )
        let cell = NSCollectionLayoutItem(layoutSize: cellSize)
        cell.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
        
        let cellGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1 / 3)
        )
        
        let cellGroup = NSCollectionLayoutGroup.horizontal(layoutSize: cellGroupSize, subitems: [cell])
        cellGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 80, bottom: 0, trailing: 80)

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
        let cellSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1 / 6),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let cell = NSCollectionLayoutItem(layoutSize: cellSize)
        cell.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1 / 2 - 0.09)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [cell])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
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
        
        let miniCompositionalLayout = UICollectionViewCompositionalLayout(section: section)
        
        return miniCompositionalLayout
    }
    
    func setupView() {
        dataSource = bookmarksDataSource
        register(
            EditingBookmarkCell.self,
            forCellWithReuseIdentifier: EditingBookmarkCell.editingCollectionViewCellReuseID
        )
        
        register(
            BookmarkCell.self,
            forCellWithReuseIdentifier: BookmarkCell.collectionViewCellReuseID
        )
        
        register(
            BookmarksHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BookmarksHeaderView.reuseidentifier
        )
        
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
    }
}

@objc private extension BookmarksCollectionView {
    func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
        let location = sender.location(in: self)
        guard let indexPath = self.indexPathForItem(at: location) else { return }
        guard let cell = cellForItem(at: indexPath) as? EditingBookmarkCell else {
            return
        }
        
        switch sender.state {
        case .began :
            cell.isHighlighted = true
            self.beginInteractiveMovementForItem(at: indexPath)
        case .changed:
            let currentLocation = sender.location(in: self)
            self.updateInteractiveMovementTargetPosition(currentLocation)
            print(currentLocation)
            updateAnimation()
        case .ended:
            endInteractiveMovement()
            let currentLocation = sender.location(in: self)
            guard
                let index = indexPathForItem(at: currentLocation),
                let cell = cellForItem(at: index) else { return }
            cell.isHighlighted = false
            updateAnimation()
        default:
            break
        }
    }
}
