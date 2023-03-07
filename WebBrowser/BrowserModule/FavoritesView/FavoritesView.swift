//
//  FavoritesView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 04.12.2022.
//

import UIKit

protocol FavoritesViewDelegate: AnyObject {
    func hideKeyboard()
    func deleteSelectedCells()
    func hideFavoritesViewIfNedded()
}

final class FavoritesView: UIView {
    private(set) lazy var collectionView = BookmarksCollectionView()
    private lazy var toolbar: FavoritesViewToolbar? = {
        guard Interface.orientation == .portrait else { return nil }
        let toolbar = FavoritesViewToolbar()
        toolbar.favoritesView = self
        return toolbar
    }()
    
    weak var delegate: FavoritesViewDelegate?
    weak var tabController: TabViewController? {
        didSet {
            collectionView.delegate = tabController
        }
    }
    
    override var alpha: CGFloat {
        willSet {
            if newValue == 1 {
                collectionView.contentOffset.y = 0
                collectionView.reloadData()
            }
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelButtonHidden(_ isHidden: Bool, hasLoadedURL: Bool) {
        if hasLoadedURL && self.alpha == 1 {
            let alpha = 1.0
            toolbar?.showCancelButtonWith(alpha)
            return
        } else {
            let alpha = isHidden ? 0.0 : 1.0
            toolbar?.showCancelButtonWith(alpha)
        }
    }
    
    func updateTrashButton() {
        let alpha = collectionView.indexPathsForSelectedItems?.isEmpty ?? false ? 0.0 : 1.0
        toolbar?.showTrashButtonWith(alpha)
    }
    
    func editingIsFinished() {
        toolbar?.showInitialAppearance()
        collectionView.endInteractiveMovement()
        updateCollectionViewAfterEditing()
        updateTrashButton()
        let isHidden = !(tabController?.hasLoadedURl ?? false)
        cancelButtonHidden(isHidden, hasLoadedURL: tabController?.hasLoadedURl ?? false)
    }
    
    func updateCollectionViewAfterEditing() {
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            indexPaths.forEach { collectionView.deselectItem(at: $0, animated: true) }
        }
        collectionView.isEditingMode = false
        collectionView.allowsMultipleSelection = false
        collectionView.indexPathsForVisibleItems.forEach { indexPath in
            guard let cell = collectionView.cellForItem(at: indexPath) as? EditingBookmarkCell else {
                return
            }
            cell.isHighlighted = false
            UIView.animate(withDuration: 0.2) {
                cell.roundImageView.alpha = 0
            } completion: { _ in
                if indexPath.row == self.collectionView.indexPathsForVisibleItems.count - 1 {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    
    func collectionViewDeleteCells(at indexPaths: [IndexPath]) {
        collectionView.deleteCells(at: indexPaths)
        updateTrashButton()
    }
    
    func editButtonTapped() {
        delegate?.hideKeyboard()
        cancelButtonHidden(true, hasLoadedURL: false)
        collectionView.isEditingMode = true
        collectionView.allowsMultipleSelection = true
        collectionView.reloadData()
    }
    
    func doneButtonTapped() {
        editingIsFinished()
    }
    
    func trashButtonTapped() {
        delegate?.deleteSelectedCells()
    }
    
    func cancelButtonTapped() {
        delegate?.hideFavoritesViewIfNedded()
        delegate?.hideKeyboard()
    }
}

private extension FavoritesView {
    func setupView() {
        if toolbar != nil {
            setupToolbar()
        }
        setupCollectionView()
    }
    
    func setupToolbar() {
        guard let toolbar else { return }
        addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        let toolbarHeight = Interface.screenHeight > 750 ? 100.0 : 60.0
        
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: self.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolbar.heightAnchor.constraint(equalToConstant: toolbarHeight)
        ])
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.layer.masksToBounds = false
        collectionView.panGestureRecognizer.addTarget(
            self,
            action: #selector(collectionViewDidScroll)
        )
        
        if let toolbar {
            insertSubview(collectionView, belowSubview: toolbar)
            collectionView.topAnchor.constraint(
                equalTo: toolbar.bottomAnchor
            ).isActive = true
        } else {
            addSubview(collectionView)
            collectionView.topAnchor.constraint(
                equalTo: self.topAnchor,
                constant: 30
            ).isActive = true
        }
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

@objc private extension FavoritesView {
    func collectionViewDidScroll() {
        delegate?.hideKeyboard()
    }
}
