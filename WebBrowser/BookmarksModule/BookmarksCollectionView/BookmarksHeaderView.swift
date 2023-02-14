//
//  BookmarksHeaderView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 25.12.2022.
//

import UIKit

final class BookmarksHeaderView: UICollectionReusableView {
    static let reuseidentifier = String(describing: BookmarksHeaderView.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension BookmarksHeaderView {
    func setupView() {
        let titleLabel = UILabel()
        titleLabel.text = "Favorites"
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        titleLabel.sizeToFit()
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 18),
            titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
