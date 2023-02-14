//
//  LandscapeTabViewController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 09.02.2023.
//

import UIKit

class LandscapeTabViewController: SuperTabViewController {
    private lazy var favoritesModel = FavoritesModel()
    private lazy var favoritesView = BookmarksView(controller: self)
    private(set) lazy var landscapeTabView = LandscapeTabView(favoritesView: favoritesView)

    weak var controller: LandscapeViewController?
    
    
    override func loadView() {
        super.loadView()
        self.view = landscapeTabView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TABVIewController")
    }
}

private extension LandscapeTabViewController {
    func loadWebsite(from url: URL) {
        landscapeTabView.webView.load(URLRequest(url: url))
        hideFavoritesViewIfNedded()
    }
    
    func hideFavoritesViewIfNedded() {
//        guard hasLoadedURl else { return }
        landscapeTabView.hideFavoritesView()
//        updateStatusBarColor()
    }
}

extension LandscapeTabViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let bookmark = favoritesModel.bookmarks[indexPath.row]
        loadWebsite(from: bookmark.url)
        controller?.bookmarkWasSelected(self, selected: bookmark)
    }
}
