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
    private let bookmarksCollectionDataSource = BookmarksCollectionDataSource.shared
    private lazy var longPressGesture: UILongPressGestureRecognizer = {
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
        startBookmarksObserve()
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
    func setupView() {
        dataSource = bookmarksCollectionDataSource
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
    
    func startBookmarksObserve() {
        NotificationCenter.default
            .addObserver(
                self,
                selector: #selector(bookmarksCollectionHasChanged),
                name: .bookmarksCollectionHasChanged,
                object: nil
            )
    }
}

@objc private extension BookmarksCollectionView {
    func bookmarksCollectionHasChanged() {
        DispatchQueue.main.async {
            guard
                let superview = self.superview as? FavoritesView,
                    superview.alpha == 1 else { return }
            self.reloadData()
        }
    }
    
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
