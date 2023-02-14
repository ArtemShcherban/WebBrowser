//
//  BookmarkCell.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 24.12.2022.
//

import UIKit

class BookmarkCell: UICollectionViewCell {
    private(set) static var collectionViewCellReuseID = String(describing: BookmarkCell.self)

    private(set) lazy var iconImageView = UIImageView()
    private lazy var titleLabel = UILabel()
    private(set) lazy var containerView = UIView()
    private lazy var auxiliaryView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with bookmark: Bookmark) {
//        backgroundColor = .red.withAlphaComponent(0.5)
        backgroundColor = .clear
        isSelected = false
        titleLabel.text = bookmark.title
        iconImageView.image = bookmark.icon
        animateAppearance()
    }
    
    func animateAppearance() { }
}

private extension BookmarkCell {
    func setupView() {
        layer.cornerRadius = frame.width * 0.12
        setupContainerView()
        setupImageView()
        setupAuxiliaryView()
        setupTextLabel()
    }
    
    func setupContainerView() {
        containerView.layer.cornerRadius = self.frame.width * 0.09
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOffset = CGSize(width: 0, height: 0)
        containerView.layer.shadowRadius = 7
        containerView.layer.shadowOpacity = 0.15
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.55),
            containerView.widthAnchor.constraint(equalTo: containerView.heightAnchor),
//            containerView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.78),
//            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            containerView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            containerView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setupImageView() {
        iconImageView.sizeToFit()
        iconImageView.contentMode = .scaleAspectFill
        iconImageView.backgroundColor = .white
        
        iconImageView.clipsToBounds = true
        iconImageView.layer.cornerRadius = self.frame.width * 0.09
        containerView.addSubview(iconImageView)
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
//            iconImageView.widthAnchor.constraint(
//                equalTo: self.widthAnchor,
//                constant: -self.frame.width * 0.22
//            ),
            iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor),
            iconImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            iconImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
        ])
    }
    
    func setupAuxiliaryView() {
//        auxiliaryView.backgroundColor = .yellow
        containerView.addSubview(auxiliaryView)
        auxiliaryView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            auxiliaryView.widthAnchor.constraint(equalToConstant: 10),
            auxiliaryView.topAnchor.constraint(equalTo: containerView.bottomAnchor),
            auxiliaryView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            auxiliaryView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    func setupTextLabel() {
        titleLabel.numberOfLines = 2
//        titleLabel.backgroundColor = .blue.withAlphaComponent(0.3)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        containerView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor, constant: 4),
//            titleLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 4),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
//            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            titleLabel.centerYAnchor.constraint(equalTo: auxiliaryView.centerYAnchor)
        ])
    }
}
