//
//  HeadlineCell.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.03.2023.
//

import UIKit
import Action

final class HeadlineCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: HeadlineCell.self)
    
    private lazy var titleLabel = UILabel()
    private lazy var closeButton = UIButton()
    private lazy var containerView = UIView()
    private lazy var iconImageView = UIImageView()
    private lazy var scaleConfiguration = UIImage.SymbolConfiguration(scale: .small)
    private lazy var rightBorderLayer = CAShapeLayer()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTitleLabel()
        setupIconImageView()
        updateRightBorderLayer()
    }
    
    var isSideCell = false
    var isActive = false {
        didSet {
            contentView.backgroundColor = isActive ? .tabCellLightGray : .textFieldGray
            titleLabel.textColor = isActive ? .black : .tabTitleDarkGray
            closeButton.alpha = isActive ? 1 : 0
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with headline: Headline, action: CocoaAction, isIconVisible: Bool) {
        closeButton.rx.action = action
        setIconVisibility(isIconVisible: isIconVisible)
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.text = headline.title
        iconImageView.image = headline.favoriteIcon
    }
}

private extension HeadlineCell {
    func setIconVisibility(isIconVisible: Bool) {
        if isActive {
            iconImageView.alpha = isIconVisible ? 1 : 0
        } else {
            iconImageView.alpha = 1
        }
    }
    
    func setupView() {
        contentView.backgroundColor = .white
        setupContainerView()
        setupCloseButton()
        updateRightBorderLayer()
        layer.addSublayer(rightBorderLayer)
    }
    
    func updateRightBorderLayer() {
        var strokeColor = UIColor.clear.cgColor
        if !isActive && !isSideCell {
            strokeColor = UIColor.lightGray.cgColor
        }
        rightBorderLayer.drawBorder(in: bounds, with: strokeColor)
    }
    
    func setupCloseButton() {
        let clearImage = UIImage(systemName: "clear.fill", withConfiguration: scaleConfiguration)
        closeButton.tintColor = .tabTitleDarkGray
        closeButton.setImage(clearImage, for: .normal)
        containerView.addSubview(closeButton)

        closeButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: self.topAnchor),
            closeButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 4),
            closeButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupContainerView() {
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: self.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    func setupIconImageView() {
        iconImageView.tintColor = .tabTitleDarkGray
        containerView.addSubview(iconImageView)

        iconImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            iconImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconImageView.leadingAnchor.constraint(greaterThanOrEqualTo: closeButton.leadingAnchor),
            iconImageView.trailingAnchor.constraint(equalTo: titleLabel.leadingAnchor, constant: -6)
        ])
    }
    
    func setupTitleLabel() {
        titleLabel.textAlignment = .center
        containerView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 249), for: .horizontal)

        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(greaterThanOrEqualTo: containerView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            titleLabel.widthAnchor.constraint(lessThanOrEqualTo: self.widthAnchor, multiplier: 0.55)
        ])
    }
}

private extension CAShapeLayer {
    func drawBorder(in rect: CGRect, with strokeColor: CGColor) {
        let borderPath = UIBezierPath()
        borderPath.move(to: CGPoint(
            x: rect.maxX,
            y: rect.minY)
        )
        borderPath.addLine(to: CGPoint(
            x: rect.maxX,
            y: rect.maxY)
        )
        
        frame = rect
        path = borderPath.cgPath
        lineWidth = 0.5
        self.strokeColor = strokeColor
        fillColor = nil
    }
}
