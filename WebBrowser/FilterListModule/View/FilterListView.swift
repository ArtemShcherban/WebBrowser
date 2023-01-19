//
//  FilterListView.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 10.12.2022.
//

import UIKit

protocol FilterListViewDelegate: AnyObject {
    func backButtonTapped()
}

final class FilterListView: UIView {
    lazy var tableView = UITableView()
    lazy var backButton: UIButton = {
        setupBackButton()
    }()
    
    weak var delegate: FilterListViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FilterListView {
    func setupView() {
        backgroundColor = .white
        setupTableView()
    }
    
    func setupBackButton() -> UIButton {
        let backButton = UIButton(type: .system)
        backButton.setImage(
            UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate),
            for: .normal
        )
        backButton.imageView?.contentMode = .scaleAspectFill
        backButton.setAttributedTitle(
            NSAttributedString(
            string: "Web Browser",
            attributes: [
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)
            ]),
            for: .normal
        )
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        return backButton
    }
    
    func setupTableView() {
        addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            tableView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            tableView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

@objc private extension FilterListView {
    func backButtonTapped() {
        delegate?.backButtonTapped()
    }
}
