//
//  CollectionViewCell.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 24.12.2022.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static let reuseidentifier = String(describing: CollectionViewCell.self)
    lazy var favoriteIconImageView = UIImageView()
    lazy var websiteNameLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension CollectionViewCell {
    func setupView() {
        backgroundColor = .white
        layer.cornerRadius = frame.width * 0.12
        setupImageView()
        setupTextLabel()

    }
    
    func setupImageView() {
        favoriteIconImageView.backgroundColor = .white
        favoriteIconImageView.backgroundColor = UIColor(red: 87 / 255, green: 14 / 255, blue: 202 / 255, alpha: 1)
        favoriteIconImageView.layer.cornerRadius = self.frame.width * 0.09
        favoriteIconImageView.layer.shadowColor = UIColor.black.cgColor
        favoriteIconImageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        favoriteIconImageView.layer.shadowRadius = 7
        favoriteIconImageView.layer.shadowOpacity = 0.15
        
        addSubview(favoriteIconImageView)
        favoriteIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoriteIconImageView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.78),
            favoriteIconImageView.heightAnchor.constraint(equalTo: favoriteIconImageView.widthAnchor),
            favoriteIconImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            favoriteIconImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8)
        ])
    }
    
    func setupTextLabel() {
        websiteNameLabel.backgroundColor = .clear
        websiteNameLabel.numberOfLines = 2
        websiteNameLabel.textAlignment = .center
//        websiteNameLabel.text = "d - Google Search search search"
        websiteNameLabel.text = "Yahoo"
        websiteNameLabel.sizeToFit()
        websiteNameLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        addSubview(websiteNameLabel)
        websiteNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            websiteNameLabel.topAnchor.constraint(equalTo: favoriteIconImageView.bottomAnchor, constant: 6),
            websiteNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            websiteNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
