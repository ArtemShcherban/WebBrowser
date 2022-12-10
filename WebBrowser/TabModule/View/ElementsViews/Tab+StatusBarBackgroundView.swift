//
//  Tab+StatusBarBackgroundView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 04.12.2022.
//

import UIKit

extension TabView {
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

private extension TabView.StatusBarBackgroundView {
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
