//
//  FilterListViewController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 10.12.2022.
//

import UIKit

final class FilterListViewController: UIViewController {
    let filterListView = FilterListView()
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
        filterListView.tableView.delegate = self
        filterListView.tableView.dataSource = self
    }
}

extension FilterListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterListModel.filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row) - \(filterListModel.filters.sorted()[indexPath.row])"
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let filter = filterListModel.filters.sorted()[indexPath.row]
        filterListModel.filters.remove(filter)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        tableView.reloadData()
    }
}
