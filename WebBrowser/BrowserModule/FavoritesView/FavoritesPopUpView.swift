//
//  FavoritesPopUpView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 01.03.2023.
//

import UIKit

class FavoritesPopUpView: UIView {
    private lazy var collectionView = BookmarksCollectionView(collectionViewType: .mini)
    
    weak var delegate: FavoritesViewDelegate?
    weak var tabController: TabViewController? {
        didSet {
            collectionView.delegate = tabController
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FavoritesPopUpView {
    func setupView() {
        layer.cornerRadius = 16
        clipsToBounds = true
        setupBlurEffectView()
        setupCollectionView()
    }
    
    func setupBlurEffectView() {
        let blurEffectView = UIVisualEffectView()
        blurEffectView.effect = UIBlurEffect(style: .systemChromeMaterialLight)
        addSubview(blurEffectView)
        
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            blurEffectView.topAnchor.constraint(equalTo: self.topAnchor),
            blurEffectView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            blurEffectView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            blurEffectView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupCollectionView() {
        collectionView.backgroundColor = .clear
        collectionView.panGestureRecognizer.addTarget(self, action: #selector(collectionViewDidScroll))
        addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 24),
            collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}

@objc private extension FavoritesPopUpView {
    func collectionViewDidScroll() {
        delegate?.hideKeyboard()
    }
}
