//
//  HeadlinesViewModel.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 07.03.2023.
//

import UIKit
import RxSwift
import RxRelay
import Action
import RxDataSources

typealias HeadlineSection = AnimatableSectionModel<String, Headline>

final class HeadlinesViewModel {
    private let networkService = IconNetworkService()
    private var sections: [HeadlineSection] = []
    private lazy var sectionsSubject: BehaviorRelay<[HeadlineSection]> = BehaviorRelay(value: [])
    var headlinesObservable: Observable<[HeadlineSection]> {
        sectionsSubject.asObservable()
    }
    
    lazy var changeActiveTab: Action<Int, Swift.Never> = { thisViewModel in
        return Action { _ in
            thisViewModel.sectionsSubject.accept(thisViewModel.sections)
            return .empty()
        }
    }(self)
    
    func deleteHeadline(at index: Int) {
        sections = sections.map { section in
            var section = section
            section.items.remove(at: index)
            return section
        }
        self.sectionsSubject.accept(sections)
    }
    
    func change(_ headline: Headline, at index: Int) {
        if sections.isEmpty {
            sections.append(HeadlineSection(model: "Headline Section", items: [headline]))
            sectionsSubject.accept(sections)
            return
        }
        
        guard sections.map({ section in section.items[safe: index] })[0] != nil else {
            sections = sections.compactMap { section in
                var section = section
                section.items += [headline]
                return section
            }
            sectionsSubject.accept(sections)
            return
        }
        
        sections = sections.compactMap { section in
            var section = section
            section.items[index].title = headline.title
            section.items[index].favoriteIcon = headline.favoriteIcon
            section.items[index].isActive = headline.isActive
            return section
        }
        sectionsSubject.accept(sections)
    }
}
