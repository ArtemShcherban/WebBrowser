//
//  BookmarkCell.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 24.12.2022.
//

import UIKit

class BookmarkCell: UICollectionViewCell {
    private(set) static var collectionViewCellReuseID = String(describing: BookmarkCell.self)
    
    private(set) var bookmark: Bookmark?
    private lazy var titleLabel = UILabel()
    private(set) lazy var containerView = UIView()
    private(set) lazy var iconImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with bookmark: Bookmark) {
        self.bookmark = bookmark
        titleLabel.text = bookmark.title
        iconImageView.image = bookmark.icon
        animateAppearance()
    }
    
    func animateAppearance() { }
}

private extension BookmarkCell {
    func setupView() {
        isSelected = false
        layer.cornerRadius = frame.width * 0.12
        setupContainerView()
        setupImageView()
        setupTextLabel()
    }
    
    func setupContainerView() {
        containerView.layer.cornerRadius = self.frame.width * 0.13
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 7
        containerView.layer.shadowOpacity = 0.15
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.93),
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setupImageView() {
        iconImageView.sizeToFit()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.backgroundColor = .white
        
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = self.frame.width * 0.13
        containerView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func setupTextLabel() {
        titleLabel.numberOfLines = 2
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor)
        ])
    }
}
