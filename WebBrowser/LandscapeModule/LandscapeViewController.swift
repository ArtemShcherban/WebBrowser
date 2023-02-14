//
//  LandscapeViewController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.02.2023.
//

import UIKit
import WebKit

final class LandscapeViewController: UIViewController {
    lazy var landscapeBrowserView = LandscapeBrowserView()

    var currentAddressBar: AddressBar {
        landscapeBrowserView.addressBar
    }
    
    override func loadView() {
        super.loadView()
        self.view = landscapeBrowserView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addLandscapeTabViewController()
    }
    
    func addLandscapeTabViewController() {
        let landscapeTabViewController = LandscapeTabViewController()
        landscapeTabViewController.controller = self
        addChild(landscapeTabViewController)
        landscapeTabViewController.didMove(toParent: self)
        let tabView = landscapeTabViewController.landscapeTabView
        landscapeBrowserView.addСontentOf(tabView)
    }
}

extension LandscapeViewController: OLDTabViewControllerDelegate {
    func tabViewController(_ tabViewController: SuperTabViewController, didStartLoadingURL: URL) {
    }
    
    func tabViewController(_ tabViewController: SuperTabViewController, didChangeLoadingProgressTo: Float) {
    }
    
    func bookmarkWasSelected(_ tabViewController: SuperTabViewController, selected bookmark: Bookmark) {
//        updateWebpageContentModeFor(tabViewController, and: bookmark.url)
        currentAddressBar.updateAfterLoadingBookmark(text: bookmark.url.absoluteString)
        dismissKeyboard()
    }
    
    func hostHasChanged() {
    }
    
    func backForwardListHasChanged(_ canGoBack: Bool, _ canGoForward: Bool) {
    }
    
    func heartButtonEnabled() {
    }
    
    func activateToolbar() {
    }
    
    func hideKeyboard() {
    }

}

//extension LandscapeViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let bookmark = favoritesModel.bookmarks[indexPath.row]
//        landscapeTabView.webView.load(URLRequest(url: bookmark.url))
//        landscapeTabView.favoritesView.alpha = 0
//    }
//}

//extension LandscapeViewController: UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//        BookmarkPresentTransition()
//    }
//}



//        landscapeWebBrowserView.delegate = self
//        landscapeWebBrowserView.showFavoritesView()
        
//        let button = UIButton(frame: CGRect(x: 200, y: 100, width: 200, height: 50))
//        button.backgroundColor = .loadingBlue
//        view.addSubview(button)
//
//        button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
        
//        let bookmarksVC = BookmarksViewController()
//        bookmarksVC.transitioningDelegate = self
//        bookmarksVC.modalPresentationStyle = .currentContext
//        present(bookmarksVC, animated: true)

//@objc func tapped() {
//        landscapeWebBrowserView.favoritesView.parentViewController = self
//        landscapeWebBrowserView.favoritesView.createCollectionView()
//        let bookmarksVC = BookmarksViewController()
//        bookmarksVC.transitioningDelegate = landscapeWebBrowserView.favoritesView
//        bookmarksVC.modalPresentationStyle = .currentContext
//        present(bookmarksVC, animated: true)
//}

//@objc func tapped() {
//    guard let topcontroller = navigationController?.topViewController as? LandscapeViewController else {
//   return
//   }
//    topcontroller.landscapeWebBrowserView.webView.removeFromSuperview()
//    navigationController?.popViewController(animated: false)
//
//
//    navigationController?.viewControllers.forEach({ controller in
//        guard let controller = controller as? LandscapeViewController else { return }
//        print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
//        print("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
//        print("Controller: \(controller)")
//        print("FavoritesView: \(controller.favoritesView)")
//        print("FavoritesViewController: \(controller.favoritesView?.controller)")
//    })
//}

//func printData() {
//    navigationController?.viewControllers.forEach({ controller in
//        guard let controller = controller as? LandscapeViewController else { return }
//        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
//        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
//        print("Controller: \(controller)")
//        print("FavoritesView: \(controller.favoritesView)")
//        print("FavoritesViewController: \(controller.favoritesView?.controller)")
//    })
//}
//@objc func tapped() {
//    let red = CGFloat(Int.random(in: 0...255)) / 255
//    let green = CGFloat(Int.random(in: 0...255)) / 255
//    let blue = CGFloat(Int.random(in: 0...255)) / 255
//    let backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1)
////        nextViewController.landscapeWebBrowserView.backgroundColor = backgroundColor
//
//    landscapeWebBrowserView = LandscapeWebBrowserView()
//    landscapeWebBrowserView.favoritesView = BookmarksView(controller: self)
//    landscapeWebBrowserView.showFavoritesView()
//    landscapeWebBrowserView.backgroundColor = backgroundColor
//    let button = UIButton(frame: CGRect(x: 200, y: 100, width: 200, height: 50))
//    button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
//    button.backgroundColor = .loadingBlue
//
//    landscapeWebBrowserView.addSubview(button)
//    parentController.landscapeTabViewControllers.append(landscapeWebBrowserView)
//}
//
//override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//    let portraitController = ViewController()
//    let webViews = parentController.landscapeTabViewControllers
//        .map { landscapeWebBrowserView in
//            landscapeWebBrowserView.webView
//        }
//    portraitController.webViews = webViews
//    //        let webView = landscapeWebBrowserView.webView
//    //        portraitController.webView = webView
//    portraitController.modalPresentationStyle = .fullScreen
//    present(portraitController, animated: true)
//    portraitController.plusButtonTapped()
//    }
//let button = UIButton(frame: CGRect(x: 200, y: 100, width: 200, height: 50))
//button.backgroundColor = .loadingBlue
//view.addSubview(button)
//
//button.addTarget(self, action: #selector(tapped), for: .touchUpInside)
