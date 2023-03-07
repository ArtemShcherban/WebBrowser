//
//  VerticalTabView+StatusBackgroundView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 13.02.2023.
//

import UIKit

extension VerticalTabView {
    class StatusBarBackgroundView: UIView {
        private lazy var separatorView = UIView()
        override init(frame: CGRect) {
            super.init(frame: frame)
            setupView()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        func setColor(_ color: UIColor) {
            backgroundColor = color
            separatorView.isHidden = color != .white
        }
    }
}

private extension VerticalTabView.StatusBarBackgroundView {
    func setupView() {
        backgroundColor = .white
        setupSeparatorView()
    }
    
    func setupSeparatorView() {
        separatorView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        addSubview(separatorView)
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
