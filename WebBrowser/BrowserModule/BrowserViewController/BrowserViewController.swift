//
//  BrowserViewController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit
import WebKit

class BrowserViewController: UIViewController {
    var browserView: BrowserView
    lazy var browserModel = BrowserModel()
    lazy var filterListModel = FilterListModel()
    
    lazy var isCollapsed = false
    lazy var toolbarIsHide = false
    
    var collapsingToolbarAnimator: UIViewPropertyAnimator?
    var expandingToolbarAnimator: UIViewPropertyAnimator?
    
    var currentTabIndex = 0 {
        didSet {
            updateAddressBarAfterTabChange()
            updateToolbarButtons()
        }
    }
    var tabViewControllers: [TabViewController] = []
    var currentTabController: TabViewController {
        tabViewControllers[currentTabIndex]
    }
 
    var currentAddressBar: AddressBar {
        if self as? VerticalBrowserController != nil {
            return browserView.addressBars[currentTabIndex]
        } else {
            return  browserView.addressBars[0]
        }
    }
    
    init(browserView: BrowserView) {
        self.browserView = browserView
        super.init(nibName: nil, bundle: nil)
        setupKeyboardManager()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAddressBarAfterTabChange() { }
    
    func updateToolbarButtons() {
        let backForwardButtonStatus = currentTabController.backForwardButtonStatus()
        browserView.enableToolbarButtons(with: backForwardButtonStatus, and: currentTabController.hasLoadedURl)
    }
    
    func addTabViewController(isHidden: Bool = false) {
        var tabController: TabViewController
        switch Interface.orientation {
        case .portrait:
            tabController = VerticalTabController(isHidden: isHidden)
        case .landscape:
            tabController = HorizontalTabController()
        }
        
        tabController.controller = self
        tabViewControllers.append(tabController)
        addChild(tabController)
        tabController.didMove(toParent: self)
    }
    
    func updateWebpageContentModeFor(_ tabViewController: TabViewController, and url: URL) {
        if tabViewController.hasURLHostChanged(in: url) {
            currentAddressBar.updateAaButtonMenuFor(contentMode: .mobile)
            tabViewController.updateWebViewConfiguration(with: .mobile)
        }
    }
    
    func deactivateToolbar() {
        setupCollapsingToolbarAnimator()
        collapsingToolbarAnimator?.startAnimation()
        isCollapsed = true
        currentAddressBar.updateProgressView(addressBar: isCollapsed)
        setupAddressBarExpandingTap()
    }
}

extension BrowserViewController {
    @objc func setupAddressBarExpandingTap() {
        let tapSuperview: UIView
        let tapGestureRecogniser = UITapGestureRecognizer(
            target: self,
            action: #selector(addressBarTapped)
        )
        if Interface.orientation == .portrait {
            tapSuperview = currentAddressBar
        } else {
            tapSuperview = browserView.toolbar
            currentAddressBar.isUserInteractionEnabled = false
        }
        tapSuperview.addGestureRecognizer(tapGestureRecogniser)
    }
}

@objc private extension BrowserViewController {
    func addressBarTapped() {
        toolbarIsHide = false
        activateToolbar()
    }
}
