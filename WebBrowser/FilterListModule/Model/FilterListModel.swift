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
        var words: Set<String> = []
        var result = true
        
        guard let host = url.host?.components(separatedBy: ".") else { return false }
        let component = url.pathComponents
        host.forEach { words.insert($0.lowercased()) }
        component.forEach { words.insert($0.lowercased()) }
        
        filters.forEach { filter in
            words.forEach { word in
                if word.contains(filter.lowercased()) {
                    result = false
                    return
                }
            }
        }
        return result
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
