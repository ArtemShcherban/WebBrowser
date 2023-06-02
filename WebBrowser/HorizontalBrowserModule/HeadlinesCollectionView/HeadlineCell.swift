//
//  HeadlineCell.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.03.2023.
//

import UIKit
import Action

enum HeadlineCellType {
    case active
    case left
    case right
    case plain
}

struct HeadLineCellConfiguration {
    let cellType: HeadlineCellType
    let headline: Headline
    let action: CocoaAction
    let isIconVisible: Bool
}

final class HeadlineCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: HeadlineCell.self)
    
    private lazy var titleLabel = UILabel()
    private lazy var closeButton = UIButton()
    private lazy var containerView = UIView()
    private lazy var iconImageView = UIImageView()
    private lazy var scaleConfiguration = UIImage.SymbolConfiguration(scale: .small)
    private lazy var borderLayer = CAShapeLayer()
    private var type: HeadlineCellType = .plain
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupTitleLabel()
        setupIconImageView()
        updateBorderLayer()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with configuration: HeadLineCellConfiguration) {
        type = configuration.cellType
        closeButton.rx.action = configuration.action
        setIconVisibility(isIconVisible: configuration.isIconVisible)
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.text = configuration.headline.title
        iconImageView.image = configuration.headline.favoriteIcon
        updateBorderLayer()
        contentView.backgroundColor = type == .active ? .tabCellLightGray : .textFieldGray
        titleLabel.textColor = type == .active ? .black : .tabTitleDarkGray
        closeButton.alpha = type == .active ? 1 : 0
    }
}

private extension HeadlineCell {
    func setIconVisibility(isIconVisible: Bool) {
        if type == .active {
            iconImageView.alpha = isIconVisible ? 1 : 0
        } else {
            iconImageView.alpha = 1
        }
    }
    
    func setupView() {
        contentView.backgroundColor = .white
        setupContainerView()
        setupCloseButton()
        layer.addSublayer(borderLayer)
    }
    
    func updateBorderLayer() {
        let clearColor = UIColor.clear
        let lightGrayColor = UIColor.lightGray
        switch type {
        case .active:
            borderLayer.drawBorders(in: bounds, leftStrokeColor: clearColor, rightStrokeColor: clearColor)
        case .plain:
            borderLayer.drawBorders(in: bounds, leftStrokeColor: lightGrayColor, rightStrokeColor: lightGrayColor)
        case .left:
            borderLayer.drawBorders(in: bounds, leftStrokeColor: lightGrayColor, rightStrokeColor: clearColor)
        case .right:
            borderLayer.drawBorders(in: bounds, leftStrokeColor: clearColor, rightStrokeColor: lightGrayColor)
        }
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
    func drawBorders(in rect: CGRect, leftStrokeColor: UIColor, rightStrokeColor: UIColor) {
        sublayers?.removeAll()
        var leftBorderLayer: CAShapeLayer {
            let layer = CAShapeLayer()
            let leftBorderPath = UIBezierPath()
            leftBorderPath.move(to: CGPoint(
                x: rect.minX,
                y: rect.minY)
            )
            leftBorderPath.addLine(to: CGPoint(
                x: rect.minX,
                y: rect.maxY)
            )
            layer.frame = rect
            layer.path = leftBorderPath.cgPath
            layer.lineWidth = 0.25
            layer.strokeColor = leftStrokeColor.cgColor
            layer.fillColor = nil
            return layer
        }
        
        var rightBorderLayer: CAShapeLayer {
            let layer = CAShapeLayer()
            let rightBorderPath = UIBezierPath()
            rightBorderPath.move(to: CGPoint(
                x: rect.maxX,
                y: rect.minY)
            )
            rightBorderPath.addLine(to: CGPoint(
                x: rect.maxX,
                y: rect.maxY)
            )
            layer.frame = rect
            layer.path = rightBorderPath.cgPath
            layer.lineWidth = 0.25
            layer.strokeColor = rightStrokeColor.cgColor
            return layer
        }
        addSublayer(leftBorderLayer)
        addSublayer(rightBorderLayer)
        frame = rect
    }
}
