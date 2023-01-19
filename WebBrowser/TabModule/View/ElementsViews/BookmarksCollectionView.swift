//
//  BookmarksCollectionView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 23.12.2022.
//

import UIKit

final class BookmarksCollectionView: UICollectionView {
    lazy var longPressGesture: UILongPressGestureRecognizer = {
        let longPressGesture = UILongPressGestureRecognizer(
            target: self,
            action: #selector(handleTapGesture(_:))
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
    
    func deleteCells(at indexPaths: [IndexPath]) {
        deleteItems(at: indexPaths)
        updateAnimation()
    }
    
    private func updateAnimation() {
        self.indexPathsForVisibleItems.forEach { indexPath in
            guard let cell = self.cellForItem(at: indexPath) as? EditingBookmarkCell
            else {
                return
            }
            cell.animateAppearance()
        }
    }
}

private extension BookmarksCollectionView {
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
        cellGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        
        let section = NSCollectionLayoutSection(group: cellGroup)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 2, bottom: 0, trailing: 2)
        
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
            EditingBookmarkCell.self,
            forCellWithReuseIdentifier: EditingBookmarkCell.editingCollectionViewCellReuseID
        )
        
        register(
            BookmarkCellCell.self,
            forCellWithReuseIdentifier: BookmarkCellCell.collectionViewCellReuseID
        )
        
        register(
            BookmarksHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: BookmarksHeaderView.reuseidentifier
        )
        
        self.showsHorizontalScrollIndicator = false
    }
}

@objc private extension BookmarksCollectionView {
    func handleTapGesture(_ sender: UILongPressGestureRecognizer) {
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
            updateAnimation()
        case .ended:
            endInteractiveMovement()
            let currentLocation = sender.location(in: self)
            guard
                let index = indexPathForItem(at: currentLocation),
                let cell = cellForItem(at: index) else { return }
            cell.isHighlighted = false
            updateAnimation()

            print("Ended")
        default:
            print("Default")
        }
        print("TAP GESTURE")
    }
}
