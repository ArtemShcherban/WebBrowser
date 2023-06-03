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
            var viewTransition: ViewTransition = .reload
            changeset.forEach { changeset in
                if
                    !changeset.deletedItems.isEmpty {
                    viewTransition = .animated
                } else if !changeset.insertedItems.isEmpty {
                    viewTransition =
                    self.horizontalBrowserView.headlinesCollectionView.numberOfItems(inSection: 0) < 2 ||
                    self.horizontalBrowserView.headlinesCollectionView.numberOfItems(inSection: 0) >= 7
                    ? .reload : .animated
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
    
    private func switchToTabControllerWith(index: Int) {
        currentTabController.progressObserver?.invalidate()
        browserView.addressBars[0].setLoadingProgress(0, animated: false)
        currentTabController.removeBackForwardStackObserve()
        currentTabController.isActiveSubject.accept(false)
        
        let newTabController = tabViewControllers[index]
        newTabController.startProgressObserve()
        newTabController.startBackForwardStackObserve()
        newTabController.isActiveSubject.accept(true)
        horizontalBrowserView.addСontentOf(newTabController.tabView)
        currentTabIndex = index
    }
    
    private func deleteTabController(at index: Int) -> CocoaAction {
        return CocoaAction { [weak self] _ in
            guard let self else { return .empty() }
            if (index == 0 || index == 1) && self.tabViewControllers.count == 2 {
                self.horizontalBrowserView.hideTabsCollectionView()
            } else {
                let cellCount = CGFloat(self.tabViewControllers.count - 1)
                self.horizontalBrowserView.showTabsCollectionViewWith(cellCount)
            }
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
    
    private func nextActiveItemIndex(after index: Int) -> Int {
        if index < tabViewControllers.count - 1 {
            return index + 1
        } else if index == tabViewControllers.count - 1 {
            return index - 1
        } else {
            return 0
        }
    }
    
    private func subscribeToHeadlineObservable(of tabController: TabViewController) {
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
            var cellType: HeadlineCellType
            
            if headline.isActive {
                cellType = .active
            } else if self.currentTabIndex - 1 == indexPath.row {
                cellType = .left
            } else if self.currentTabIndex + 1 == indexPath.row {
                cellType = .right
            } else {
                cellType = .plain
            }
            let configuration = HeadLineCellConfiguration(
                cellType: cellType,
                headline: headline,
                action: self.deleteTabController(at: self.currentTabIndex),
                isIconVisible: tabsCount < 6
            )
            cell.configure(with: configuration)
            return cell
        }
    }
    
    private func bindViewModel() {
        headlinesViewModel.headlinesObservable
            .bind(to: horizontalBrowserView.headlinesCollectionView.rx.items(dataSource: headlinesDataSource))
            .disposed(by: disposeBag)
        
        horizontalBrowserView.headlinesCollectionView.rx.itemSelected
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
        horizontalBrowserView.headlinesCollectionView.moveContentIfNedeed()
    }
}
