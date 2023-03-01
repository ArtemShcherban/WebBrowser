//
//  FavoritesView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 04.12.2022.
//

import UIKit

protocol FavoritesViewDelegate: AnyObject {
    func collectionViewDidScroll(_: UIPanGestureRecognizer)
    func cancelButtonTapped()
    func trashButtonTapped()
    func hideFavoritesViewIfNedded()
}

final class FavoritesView: UIView {
    private(set) var favoritesModel: FavoritesModel
    private var dataSource: DataSource
    private lazy var toolbar = UIToolbar(
        frame: CGRect(
            x: 0,
            y: 0,
            width: 100,
            height: 100)
    )
    private lazy var cancelButton = UIButton(type: .system)
    private lazy var trashButton = UIButton(type: .system)
    private lazy var editButton = UIButton(type: .system)
    private(set) lazy var collectionView = BookmarksCollectionView()
    
    var toolbarTopConstraints: NSLayoutConstraint?
    
//    var collectionViewToolbarTopConstraint: NSLayoutConstraint?
    var collectionViewTopConstraint: NSLayoutConstraint?
    
//    weak var collectionDelegate: TabViewController?
    weak var collectionViewDelegate: PortraitTabController?
    
    weak var tabController: TabViewController? {
        didSet {
            collectionView.delegate = tabController
            collectionView.reloadData()
        }
    }
    
    override var alpha: CGFloat {
        willSet {
            newValue == 1 ? collectionView.contentOffset.y = 0  : nil
        }
    }
    
    init(favoritesModel: FavoritesModel) {
        self.favoritesModel = favoritesModel
        self.dataSource = DataSource(favoritesModel: favoritesModel)
        super.init(frame: .zero)
        setupView()
    }
    
//    init(delegate: PortraitTabController?) { // DELETE
//        self.favoritesModel = FavoritesModel()
//        self.dataSource = DataSource(favoritesModel: favoritesModel)
//        super.init(frame: .zero)
////        self.delegate = delegate
////        self.collectionViewDelegate = delegate
//        setupView()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        updateInterface()
    }
    
    private func updateInterface() {
        switch Interface.orientation {
        case .portrait:
            toolbarTopConstraints?.constant = 0
        case .landscape:
            toolbarTopConstraints?.constant = -110
            collectionView.reloadData()
        }
    }
    
    func cancelButtonHidden(_ isHidden: Bool, hasLoadedURL: Bool) {
        if
            hasLoadedURL,
            alpha == 1 {
            UIView.animate(withDuration: 0.2) {
                self.cancelButton.alpha = 1
            }
            cancelButton.addTarget(self, action: #selector(cancelFavoritesView), for: .touchUpInside)
        } else {
            UIView.animate(withDuration: 0.1) {
                self.cancelButton.alpha = isHidden ? 0 : 1
            }
        }
    }
    
    func updateTrashButton() {
        UIView.animate(withDuration: 0.1) {
            self.trashButton.alpha =
            self.collectionView.indexPathsForSelectedItems?.isEmpty ?? false ? 0 : 1
        }
    }
    
    func editingIsFinished() {
        editButton.isSelected.toggle()
        editButton.removeTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        collectionView.endInteractiveMovement()
        updateCollectionViewAfterEditing()
        updateTrashButton()
        cancelButtonHidden(false, hasLoadedURL: collectionViewDelegate?.hasLoadedURl ?? false)
    }
    
    func updateCollectionViewAfterEditing() {
        if let indexPaths = collectionView.indexPathsForSelectedItems {
            indexPaths.forEach { collectionView.deselectItem(at: $0, animated: true) }
        }
        collectionView.isEditingMode = editButton.isSelected
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
//        indexPaths.forEach { indexPath in
//            guard let cell = collectionView.cellForItem(at: indexPath) as? EditingBookmarkCell else { return }
//            UIView.animate(withDuration: 0.05) {
//                cell.alpha = 0
//                cell.roundImageView.alpha = 0
//            }
//        }
        collectionView.deleteItems(at: indexPaths)
        updateTrashButton()
    }
}

private extension FavoritesView {
    func setupView() {
        setupToolbar()
        setupCollectionView()
        setupEditButton()
        setupCancelButton()
        setupTrashButton()
    }
    
    func setupToolbar() {
        guard Interface.orientation == .portrait else { return }
        addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        toolbarTopConstraints = toolbar.topAnchor.constraint(equalTo: self.topAnchor)
//        toolbarTopConstraints?.constant = Interface.orientation == .portrait ? -0 : -110
        guard let toolbarTopConstraints else { return }
        
        NSLayoutConstraint.activate([
            toolbarTopConstraints,
            toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            toolbar.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12)
            toolbar.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.panGestureRecognizer.addTarget(
            self,
            action: #selector(panGestureDelegateAction(_:))
        )
        collectionView.layer.masksToBounds = false
        insertSubview(collectionView, belowSubview: toolbar)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        if Interface.orientation == .portrait {
            collectionViewTopConstraint = collectionView.topAnchor.constraint(
                equalTo: self.toolbar.bottomAnchor,
                constant: 0.0
            )
        } else {
            collectionViewTopConstraint = collectionView.topAnchor.constraint(
                equalTo: self.topAnchor
            )
        }
        
        guard let collectionViewTopConstraint else { return }
        
        NSLayoutConstraint.activate([
            collectionViewTopConstraint,
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupEditButton() {
        editButton.tintColor = .clear
        editButton.setTitleColor(.systemBlue, for: .normal)
        editButton.setTitleColor(.systemBlue, for: .selected)
        editButton.isSelected = false
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitle("Done", for: .selected)
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        toolbar.addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: toolbar.leadingAnchor, constant: 24),
            editButton.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -4)
        ])
    }
    
    func setupCancelButton() {
        cancelButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelButton.alpha = 0
        cancelButton.setTitle("Cancel", for: .normal)
        toolbar.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -24),
            cancelButton.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -4)
        ])
    }
    
    func setupTrashButton() {
        trashButton.alpha = 0
        let trashImage = UIImage(systemName: "trash")
        trashButton.setImage(trashImage, for: .normal)
        trashButton.addTarget(self, action: #selector(trashButtonTapped), for: .touchUpInside)
        
        toolbar.addSubview(trashButton)
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trashButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -24),
            trashButton.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -4)
        ])
    }
}

@objc private extension FavoritesView {
    func panGestureDelegateAction(_ sender: UIPanGestureRecognizer) {
        tabController?.collectionViewDidScroll(sender)
    }
    
    func hideKeyboard() {
        tabController?.hideFavoritesViewIfNedded()
        tabController?.cancelButtonTapped()
    }
    
    func editButtonTapped() {
        editButton.isSelected.toggle()
        tabController?.controller?.hideKeyboard()
        cancelButtonHidden(true, hasLoadedURL: false)
        collectionView.isEditingMode = editButton.isSelected
        editButton.removeTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        collectionView.allowsMultipleSelection = true
        collectionView.reloadData()
    }
    
    func doneButtonTapped() {
        editingIsFinished()
    }
    
    func trashButtonTapped() {
        tabController?.trashButtonTapped()
    }
    
    func cancelFavoritesView() { // RENAME 🥸🥸🥸🥸🥸🥸
        cancelButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        tabController?.hideFavoritesViewIfNedded()
    }
}
