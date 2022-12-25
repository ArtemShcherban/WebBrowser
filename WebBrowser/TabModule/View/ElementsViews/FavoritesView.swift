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
    func hideFavoritesViewIfNedded()
}

final class FavoritesView: UIView {
    private lazy var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    private lazy var cancelButton = UIButton(type: .system)
    private lazy var collectionView = CollectionView(frame: .zero)
    
    weak var delegate: FavoritesViewDelegate?
    
    override var alpha: CGFloat {
        willSet {
            newValue == 1 ? collectionView.contentOffset.y = 0  : nil
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        print(UIScreen.main.bounds)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FavoritesView {
    func setupView() {
        backgroundColor = .white
        setupToolbar()
        setupCollectionView()
        setupCancelButton()
    }
    
    func cancelButtonHidden(_ isHidden: Bool, hasLoadedURL: Bool) {
        if
            hasLoadedURL,
            alpha == 1 {
            cancelButton.alpha = 1
            cancelButton.addTarget(self, action: #selector(cancelFavoritesView), for: .touchUpInside)
        } else {
            cancelButton.alpha = isHidden ? 0 : 1
        }
    }
}

private extension FavoritesView {
    func setupCancelButton() {
        cancelButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelButton.alpha = 0
        cancelButton.setTitle("Cancel", for: .normal)
        addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.trailingAnchor.constraint(equalTo: toolbar.trailingAnchor, constant: -24),
            cancelButton.bottomAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: -4)
        ])
    }
        
    func setupToolbar() {
        addSubview(toolbar)
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: self.topAnchor),
            toolbar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            toolbar.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.12)
        ])
    }
    
    func setupCollectionView() {
        collectionView.panGestureRecognizer.addTarget(
            self,
            action: #selector(panGestureDelegateAction(_:))
        )
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.layer.masksToBounds = false
        insertSubview(collectionView, belowSubview: toolbar)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 3),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

@objc private extension FavoritesView {
    func panGestureDelegateAction(_ sender: UIPanGestureRecognizer) {
        delegate?.collectionViewDidScroll(sender)
    }
    
    func hideKeyboard() {
        delegate?.hideFavoritesViewIfNedded()
        delegate?.cancelButtonTapped()
    }
    
    func cancelFavoritesView() {
        cancelButton.addTarget(self, action: #selector(hideKeyboard), for: .touchUpInside)
        delegate?.hideFavoritesViewIfNedded()
    }
}

extension FavoritesView: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        50
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CollectionViewCell.reuseidentifier,
            for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: FavoritesHeaderView.reuseidentifier,
            for: indexPath) as? FavoritesHeaderView else { return UICollectionReusableView() }
       
        return headerView
    }
}
