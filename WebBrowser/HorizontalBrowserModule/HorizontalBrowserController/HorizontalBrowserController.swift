//
//  HorizontalBrowserController.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 11.02.2023.
//

import UIKit
import RxSwift
import Action
import RxDataSources

class HorizontalBrowserController: BrowserViewController {
    private let disposeBag = DisposeBag()
    let horizontalBrowserView = HorizontalBrowserView()
    private let headlinesViewModel = HeadlinesViewModel()
    private lazy var headlinesDataSource = RxCollectionViewSectionedAnimatedDataSource<HeadlineSection>(
        decideViewTransition: { _, _, changeset in
            var viewTransition: ViewTransition = changeset.isEmpty ? .reload : .animated
            changeset.forEach { changeset in
                if
                    !changeset.updatedItems.isEmpty {
                    viewTransition = .reload
                }
            }
            return viewTransition
        },
        configureCell: configureCell
    )
    
    init() {
        super.init(browserView: horizontalBrowserView)
        horizontalBrowserView.controller = self
    }
    
    override func loadView() {
        super.loadView()
        self.view = horizontalBrowserView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startTabViewControllerHasAddedObserve()
        horizontalBrowserView.addAddressBar()
        addTabViewController()
        NotificationCenter.default.post(name: .tabViewControllerHasAdded, object: nil)
        bindViewModel()
    }
    
    override func addTabViewController(isHidden: Bool = false) {
        if !tabViewControllers.isEmpty {
            currentTabController.removeBackForwardStackObserve()
            currentTabController.isActiveSubject.accept(false)
        }
        super.addTabViewController(isHidden: isHidden)
        guard let lastTabController = tabViewControllers.last as? HorizontalTabController else { return }
        subscribeToHeadlineObservable(of: lastTabController)
        horizontalBrowserView.addСontentOf(lastTabController.tabView)
    }
    
    override func updateAddressBarAfterTabChange() {
        let url = currentTabController.tabView.webView.url
        currentAddressBar.textField.text = url?.absoluteString
        currentAddressBar.domainTitleString = browserModel.getDomain(from: url)
        currentAddressBar.textField.activityState = .inactive
    }
    
    func switchToTabControllerWith(index: Int) {
        currentTabController.removeBackForwardStackObserve()
        currentTabController.isActiveSubject.accept(false)
        let newTabController = tabViewControllers[index]
        newTabController.startBackForwardStackObserve()
        newTabController.isActiveSubject.accept(true)
        horizontalBrowserView.addСontentOf(newTabController.tabView)
        currentTabIndex = index
        horizontalBrowserView.tabsCollectionView.reloadData()
    }
    
    func deleteTabController(at index: Int) -> CocoaAction {
        return CocoaAction { [weak self] _ in
            guard let self else { return .empty() }
            if (index == 0 || index == 1) && self.tabViewControllers.count == 2 {
                self.horizontalBrowserView.hideTabsCollectionView()
            } else {
                let cellCount = CGFloat(self.tabViewControllers.count - 1)
                self.horizontalBrowserView.showTabsCollectionViewWith(cellCount)
            }
            self.horizontalBrowserView.tabsCollectionView.moveContentIfNedeed()
            let nextActiveTabController = self.tabViewControllers[self.nextActiveItemIndex(after: index)]
            nextActiveTabController.isActiveSubject.accept(true)
            self.tabViewControllers.remove(at: index)
            self.currentTabIndex = self.tabViewControllers.count == index ? self.tabViewControllers.count - 1 : index
            self.headlinesViewModel.deleteHeadline(at: index)
            self.currentTabController.startBackForwardStackObserve()
            self.horizontalBrowserView.addСontentOf(self.currentTabController.tabView)
            return .empty()
        }
    }
    
    func nextActiveItemIndex(after index: Int) -> Int {
        if index < tabViewControllers.count - 1 {
            return index + 1
        } else if index == tabViewControllers.count - 1 {
            return index - 1
        } else {
            return 0
        }
    }
    
    func subscribeToHeadlineObservable(of tabController: TabViewController) {
        tabController.headline
            .subscribe { [weak self] headline in
                guard
                    let self,
                    let index = self.tabViewControllers.firstIndex(of: tabController) else { return }
                
                self.headlinesViewModel.change(headline, at: index)
            }
            .disposed(by: disposeBag)
    }
    
    private var configureCell: RxCollectionViewSectionedAnimatedDataSource<HeadlineSection>.ConfigureCell {
        return {  [ weak self ] _, collectionView, indexPath, headline in
            guard
                let self,
                let cell = collectionView.dequeueReusableCell(
                    withReuseIdentifier: HeadlineCell.reuseIdentifier, for: indexPath) as? HeadlineCell else {
                return UICollectionViewCell()
            }
            
            let tabsCount = self.tabViewControllers.count
            
            cell.isSideCell = (self.currentTabIndex - 1 == indexPath.row || tabsCount - 1 == indexPath.row)
            
            cell.isActive = headline.isActive
            
            collectionView.indexPathsForVisibleItems
                .filter { indexPath in
                    indexPath.row != self.currentTabIndex &&
                    indexPath.row != self.currentTabIndex - 1
                }
                .forEach { indexPath in
                    guard let visibleCell = collectionView.cellForItem(at: indexPath) as? HeadlineCell else { return }
                    visibleCell.isSideCell = false
                }
            
            cell.configure(
                with: headline,
                action: self.deleteTabController(at: self.currentTabIndex),
                isIconVisible: tabsCount < 6
            )
            return cell
        }
    }
    
    func bindViewModel() {
        headlinesViewModel.headlinesObservable
            .bind(to: horizontalBrowserView.tabsCollectionView.rx.items(dataSource: headlinesDataSource))
            .disposed(by: disposeBag)
        
        horizontalBrowserView.tabsCollectionView.rx.itemSelected
            .flatMap { [weak self] indexPath -> Observable<Int> in
                self?.switchToTabControllerWith(index: indexPath.row)
                return .just(indexPath.row)
            }
            .bind(to: headlinesViewModel.changeActiveTab.inputs)
            .disposed(by: disposeBag)
    }
}

private extension HorizontalBrowserController {
    func startTabViewControllerHasAddedObserve() {
        let center = NotificationCenter.default
        center.addObserver(
            self, selector: #selector(tabViewControllerHasAdded), name: .tabViewControllerHasAdded, object: nil
        )
    }
    
    @objc func tabViewControllerHasAdded() {
        if tabViewControllers.count > 1 {
            let cellCount = CGFloat(tabViewControllers.count)
            horizontalBrowserView.showTabsCollectionViewWith(cellCount)
        }
        currentTabController.tabModel.createStartPage(count: currentTabIndex)
        horizontalBrowserView.tabsCollectionView.moveContentIfNedeed()
    }
}
