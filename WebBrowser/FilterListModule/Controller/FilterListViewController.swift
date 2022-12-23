//
//  FilterListViewController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 10.12.2022.
//

import UIKit

final class FilterListViewController: UIViewController {
    private lazy var filterListView: FilterListView = {
        let filterListView = FilterListView()
        filterListView.delegate = self
        filterListView.tableView.delegate = self
        filterListView.tableView.dataSource = self
        return filterListView
    }()
    
    let filterListModel: FilterListModel
    
    init(filterListModel: FilterListModel) {
        self.filterListModel = filterListModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        self.view = filterListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: filterListView.backButton)
    }
}

extension FilterListViewController: FilterListViewDelegate {
    func backButtonTapped() {
        dismiss(animated: true)
    }
}

extension FilterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterListModel.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FilterListCell(style: .default, reuseIdentifier: nil)
        cell.configure(with: filterListModel.filters.sorted()[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        filterListModel.removeFilter(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        filterListModel.filters.isEmpty ? "You filter's list is empty...(" : "Filter's list:"
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
