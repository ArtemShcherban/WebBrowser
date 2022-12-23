//
//  FilterListModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 10.12.2022.
//

import Foundation

final class FilterListModel {
    private lazy var userDefaults = UserDefaults.standard
    var filters: Set<String> = [] {
        didSet {
            saveToUserDefaults()
        }
    }
    
    init() {
        readFromUserDefaults()
    }
    
    func isAllowedURL(_ url: URL) -> Bool {
        let urlString = url.absoluteString.lowercased()
        var isAllowedURL = true
        
        for filter in filters {
            if isAllowedURL {
                isAllowedURL = !urlString.contains(filter.lowercased())
            } else {
                return isAllowedURL
            }
        }
        return isAllowedURL
    }
    
    func removeFilter(at row: Int) {
        let filter = filters.sorted()[row]
        filters.remove(filter)
    }
}

private extension FilterListModel {
    func saveToUserDefaults() {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(filters) else { return }
        userDefaults.set(data, forKey: "filters")
    }
    
    func readFromUserDefaults() {
        let decoder = JSONDecoder()
        guard
            let data = userDefaults.object(forKey: "filters") as? Data,
            let filters = try? decoder.decode(Set<String>.self, from: data)
        else {
            return
        }
        self.filters = filters
    }
}
