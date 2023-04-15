//
//  TabCell.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.03.2023.
//

import UIKit

final class TabCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: TabCell.self)
    
    private lazy var titleLabel = UILabel()
    private lazy var closeButton = UIButton()
    private lazy var containerView = UIView()
    private lazy var favoriteIconImageView = UIImageView()
    private lazy var rightBorderLayer = CALayer()
    private lazy var scaleConfiguration = UIImage.SymbolConfiguration(scale: .small)
    
    private lazy var closeButtonLeadingConstraint =
    closeButton.trailingAnchor.constraint(equalTo: containerView.leadingAnchor)
    private lazy var containerViewLeadingConstraint =
    containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
    
    var isSideCell = false
    var isActive = false {
        didSet {
            setupRightBorder()
            contentView.backgroundColor = isActive ? .tabCellLightGray : .textFieldGray
            titleLabel.textColor = isActive ? .black : .tabTitleDarkGray
            closeButton.alpha = isActive ? 1 : 0
        }
    }
    
    var closeButtonTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        isSelected = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with webpageTitle: Headline, isFavoriteIconVisible: Bool) {
        setLogoVisibility(isFavoriteIconVisible: isFavoriteIconVisible)
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.text = webpageTitle.title
        favoriteIconImageView.image = webpageTitle.favoriteIcon
    }
    
    func setLogoVisibility(isFavoriteIconVisible: Bool) {
        if isActive {
            favoriteIconImageView.alpha = isFavoriteIconVisible ? 1 : 0
        } else {
            favoriteIconImageView.alpha = 1
        }
        if isFavoriteIconVisible {
            containerViewLeadingConstraint.isActive = false
            closeButtonLeadingConstraint.isActive = true
        } else {
            closeButtonLeadingConstraint.isActive = false
            containerViewLeadingConstraint.isActive = true
        }
    }
    
    func setupRightBorder() {
        if let sublayers = layer.sublayers, sublayers.contains(rightBorderLayer) {
            layer.sublayers?.removeAll { layer in
                layer == rightBorderLayer
            }
        }
        if !isActive && !isSideCell {
            rightBorderLayer = layer.rightBorder(thickness: 0.5, color: .lightGray)
            layer.addSublayer(rightBorderLayer)
        }
    }
}

private extension TabCell {
    func setupView() {
        contentView.backgroundColor = .white
        setupContainerView()
        setupCloseButton()
        setupTitleLabel()
        setupLogoImageView()
    }
    
    func setupCloseButton() {
        let clearImage = UIImage(systemName: "clear.fill", withConfiguration: scaleConfiguration)
        closeButton.tintColor = .tabTitleDarkGray
        closeButton.setImage(clearImage, for: .normal)
        closeButton.addTarget(self, action: #selector(closeButtonAction), for: .touchUpInside)
        addSubview(closeButton)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButtonLeadingConstraint.isActive = true

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            closeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupContainerView() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupLogoImageView() {
        favoriteIconImageView.alpha = 1
        favoriteIconImageView.tintColor = .tabTitleDarkGray
        addSubview(favoriteIconImageView)
        
        favoriteIconImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            favoriteIconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            favoriteIconImageView.leadingAnchor.constraint(
                greaterThanOrEqualTo: containerView.leadingAnchor, constant: 6
            ),
            favoriteIconImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -6)
        ])
    }
    
    func setupTitleLabel() {
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .horizontal)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 2),
            titleLabel.centerXAnchor.constraint(greaterThanOrEqualTo: containerView.centerXAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: containerView.trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -2)
        ])
    }
}

@objc private extension TabCell {
    func closeButtonAction() {
        closeButtonTapped?()
    }
}

private extension CALayer {
    func rightBorder(thickness: CGFloat, color: UIColor) -> CALayer {
        let border = CALayer()
        
        border.frame = CGRect(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
        border.backgroundColor = color.cgColor
        return border
    }
}
