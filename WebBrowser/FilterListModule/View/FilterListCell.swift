//
//  FilterListCell.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 12.12.2022.
//

import UIKit

final class FilterListCell: UITableViewCell {
    static let reuseidentifier = String(describing: FilterListCell.self)
    private lazy var filterTextLabel = UILabel()
    let blueView = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String) {
        setConstraints()
        filterTextLabel.backgroundColor = .white
        filterTextLabel.text = "\(text)"
        let scaleConfiguration = UIImage.SymbolConfiguration(scale: .small)
        imageView?.image = UIImage(systemName: "circle.fill", withConfiguration: scaleConfiguration)
    }
    
    private func setConstraints() {
        filterTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterTextLabel.heightAnchor.constraint(equalToConstant: 20),
            filterTextLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            filterTextLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 50),
            filterTextLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25)
        ])
    }
}

private extension FilterListCell {
    func setupView() {
        filterTextLabel.textAlignment = .left
        addSubview(filterTextLabel)
    }
}

