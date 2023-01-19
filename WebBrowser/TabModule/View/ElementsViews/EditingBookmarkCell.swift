//
//  EditingBookmarkCell.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 30.12.2022.
//

import UIKit
import Foundation

final class EditingBookmarkCell: BookmarkCellCell {
    static let editingCollectionViewCellReuseID = String(describing: EditingBookmarkCell.self)
    
    var roundBackgroundView = UIView()
    var roundImageView = UIImageView()
    var roundButtonContainer = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupFakeButton()
        
        setupRoundButtonContainer()
        
        setupRoundBackgroundView()
        setupRoundImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isSelected: Bool {
        didSet {
            updateRoundImageView()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            transformAnimation()
        }
    }
    
    override func animateAppearance() {
        self.transform = CGAffineTransform(rotationAngle: .pi / 180)
        
        UIView.animate(withDuration: 0.2) {
            self.roundImageView.alpha = 1
        }
        
        let delay = Double(Int.random(in: 0...5)) / 100
        
        UIView.animateKeyframes(
            withDuration: 0.15,
            delay: delay,
            options: [
                UIView.KeyframeAnimationOptions.repeat,
                UIView.KeyframeAnimationOptions.autoreverse,
                UIView.KeyframeAnimationOptions.allowUserInteraction
            ]
        ) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1) {
                self.transform = CGAffineTransform(rotationAngle: -.pi / 180)
            }
        }
    }
    
    private func transformAnimation() {
        switch isHighlighted {
        case true:
            UIView.animate(withDuration: 0.2) {
                self.roundButtonContainer.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                self.containerView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
        case false:
            UIView.animate(withDuration: 0.2) {
                self.roundButtonContainer.transform = .identity
                self.containerView.transform = .identity
            }
        }
    }
    
    func updateRoundImageView() {
        let scaleConfiguration = UIImage.SymbolConfiguration(weight: .thin)
        let circleImage = UIImage(systemName: "circle", withConfiguration: scaleConfiguration)
        let multiplyCircleImage = UIImage(systemName: "multiply.circle", withConfiguration: scaleConfiguration)
        UIView.transition(with: roundImageView, duration: 0.1, options: .transitionCrossDissolve) {
            self.roundImageView.image = self.isSelected ? multiplyCircleImage : circleImage
        }
        print("Round Button")
    }
}

private extension EditingBookmarkCell {
    func setupFakeButton() {
        let padView = UIButton(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        addSubview(padView)
    }
    
    func setupRoundButtonContainer() {
        addSubview(roundButtonContainer)
        roundButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roundButtonContainer.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            roundButtonContainer.heightAnchor.constraint(equalTo: roundButtonContainer.widthAnchor),
            roundButtonContainer.topAnchor.constraint(equalTo: containerView.topAnchor),
            roundButtonContainer.leadingAnchor.constraint(equalTo: containerView.leadingAnchor)
        ])
    }
    
    func setupRoundBackgroundView() {
        roundBackgroundView.layer.cornerRadius = 13
        addSubview(roundBackgroundView)
        roundBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roundBackgroundView.widthAnchor.constraint(equalToConstant: 26),
            roundBackgroundView.heightAnchor.constraint(equalTo: roundBackgroundView.widthAnchor),
            roundBackgroundView.centerXAnchor.constraint(equalTo: containerView.leadingAnchor),
            roundBackgroundView.centerYAnchor.constraint(equalTo: containerView.topAnchor)
        ])
    }
    
    func setupRoundImageView() {
        roundImageView.alpha = 0
        roundImageView.backgroundColor = .black.withAlphaComponent(0.6)
        roundImageView.layer.cornerRadius = roundBackgroundView.layer.cornerRadius
        roundImageView.tintColor = .white
        roundButtonContainer.addSubview(roundImageView)
        roundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roundImageView.widthAnchor.constraint(equalTo: roundBackgroundView.widthAnchor),
            roundImageView.heightAnchor.constraint(equalTo: roundBackgroundView.widthAnchor),
            roundImageView.centerXAnchor.constraint(equalTo: roundBackgroundView.centerXAnchor),
            roundImageView.centerYAnchor.constraint(equalTo: roundBackgroundView.centerYAnchor)
        ])
    }
}
