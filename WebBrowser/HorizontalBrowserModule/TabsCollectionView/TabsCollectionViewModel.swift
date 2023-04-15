//
//  TabsCollectionViewModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.03.2023.
//

import UIKit

final class TabsCollectionViewModel {
    let dataSource = TabsCollectionViewDataSource.shared
    let networkService = NetworkService()
    
    func addStartPageHeadline() {
        dataSource.tabsHeadlines.append(startPageHeadline)
    }
    
    func deleteTabTitle(at index: Int) {
        dataSource.tabsHeadlines.remove(at: index)
    }
    
    func changeHeadline(title: String, at index: Int) {
        dataSource.tabsHeadlines[index].title = title
    }
    
    func getFavoriteIcon(for currentTabIndex: Int, andFor url: URL) {
        guard let host = url.host else { return }
        networkService.loadIconData(for: host) { result in
            switch result {
            case .success(let data):
                guard
                    let tempFavoriteIcon = UIImage(data: data),
                    let favoriteIcon = tempFavoriteIcon.changeSizeTo(width: 16, height: 16) else { return }
                self.change(favoriteIcon: favoriteIcon, at: currentTabIndex)
            case.failure(let error):
                print(error.rawValue)
            }
        }
    }
    
   func change(favoriteIcon: UIImage, at index: Int) {
        dataSource.tabsHeadlines[index].favoriteIcon = favoriteIcon
    }
    
    private var startPageHeadline: Headline {
        let scaleConfiguration = UIImage.SymbolConfiguration(scale: .small)
        let starIcon = UIImage(
            systemName: "star.fill", withConfiguration: scaleConfiguration
        ) ?? UIImage()
       
        return Headline(
            title: "Start Page",
            favoriteIcon: starIcon
        )
    }
}
