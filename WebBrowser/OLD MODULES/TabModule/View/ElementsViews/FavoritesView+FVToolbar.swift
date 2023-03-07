//
//  FavoritesViewToolbar.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 02.03.2023.
//

import UIKit

final class FavoritesViewToolbar: UIToolbar {
    private lazy var editButton = UIButton(type: .system)
    private lazy var doneButton = UIButton(type: .system)
    private lazy var cancelButton = UIButton(type: .system)
    private lazy var trashButton = UIButton(type: .system)
    
    private var editDoneButtonsAnimator: UIViewPropertyAnimator?
    
    weak var favoritesView: FavoritesView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showInitialAppearance() {
        changeButtons()
    }
    
    func showTrashButtonWith(_ alpha: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.trashButton.alpha = alpha
        }
    }
    
    func showCancelButtonWith(_ alpha: CGFloat) {
        UIView.animate(withDuration: 0.1) {
            self.cancelButton.alpha = alpha
        }
    }
}

private extension FavoritesViewToolbar {
    func setupView() {
        setupEditButton()
        setupDoneButton()
        setupCancelButton()
        setupTrashButton()
    }
    
    func setupEditButton() {
        editButton.tintColor = .clear
        editButton.setTitleColor(.systemBlue, for: .normal)
        editButton.setTitleColor(.systemBlue, for: .selected)
        editButton.isSelected = false
        editButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitle("Done", for: .selected)
        editButton.addTarget(self, action: #selector(editButtonAction), for: .touchUpInside)
        addSubview(editButton)
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            editButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            editButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
    }
    
    func setupDoneButton() {
        doneButton.alpha = 0
        doneButton.tintColor = .clear
        doneButton.setTitleColor(.systemBlue, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self, action: #selector(doneButtonAction), for: .touchUpInside)
        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            doneButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 24),
            doneButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
    }
    
    func setupCancelButton() {
        cancelButton.alpha = 0
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(
            self,
            action: #selector(cancelButtonAction),
            for: .touchUpInside
        )
        addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            cancelButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            cancelButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
    }
    
    func setupTrashButton() {
        trashButton.alpha = 0
        let trashImage = UIImage(systemName: "trash")
        trashButton.setImage(trashImage, for: .normal)
        trashButton.addTarget(self, action: #selector(trashButtonAction), for: .touchUpInside)
        
        addSubview(trashButton)
        trashButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            trashButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -24),
            trashButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -4)
        ])
    }
}

@objc private extension FavoritesViewToolbar {
    func editButtonAction() {
        changeButtons()
        favoritesView?.editButtonTapped()
    }
    
    func doneButtonAction() {
        changeButtons()
        favoritesView?.doneButtonTapped()
    }
    
    func trashButtonAction() {
        favoritesView?.trashButtonTapped()
    }
    
    func cancelButtonAction() {
        favoritesView?.cancelButtonTapped()
    }
}

private extension FavoritesViewToolbar {
    func changeButtons() {
        if let editDoneButtonsAnimator {
            editDoneButtonsAnimator.isReversed = true
            editDoneButtonsAnimator.pausesOnCompletion = false
            editDoneButtonsAnimator.startAnimation()
        } else {
            editDoneButtonsAnimator = setupButtonsAnimator()
            editDoneButtonsAnimator?.startAnimation()
        }
    }
    
    func setupButtonsAnimator() -> UIViewPropertyAnimator {
        let animator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1)
        animator.addAnimations {
            self.editButton.alpha = 0
            self.doneButton.alpha = 1
        }
        animator.pausesOnCompletion = true
        
        animator.addCompletion { position in
            if position == .start {
                self.editDoneButtonsAnimator = nil
            }
        }
        return animator
    }
}
