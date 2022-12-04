//
//  Toolbar.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

final class Toolbar: UIToolbar {
    let leftArrowButton = UIBarButtonItem()
    let rightArrowButton = UIBarButtonItem()
    let heartButton = UIBarButtonItem()
    let plusButton = UIBarButtonItem()
    let listButton = UIBarButtonItem()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        setupButtonImage()
        setBarButtonItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Toolbar {
    func setupButtonImage() {
        let weightConfiguration = UIImage.SymbolConfiguration(weight: .semibold)
        leftArrowButton.image = UIImage(systemName: "chevron.left.circle", withConfiguration: weightConfiguration)
        rightArrowButton.image = UIImage(systemName: "chevron.right.circle", withConfiguration: weightConfiguration)
        heartButton.image = UIImage(systemName: "heart", withConfiguration: weightConfiguration)
        plusButton.image = UIImage(systemName: "plus.circle", withConfiguration: weightConfiguration)
        listButton.image = UIImage(systemName: "list.bullet", withConfiguration: weightConfiguration)
    }
    
    func setBarButtonItems() {
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        setItems(
            [
                flexibleSpace,
                leftArrowButton,
                flexibleSpace,
                rightArrowButton,
                flexibleSpace,
                heartButton,
                flexibleSpace,
                plusButton,
                flexibleSpace,
                listButton,
                flexibleSpace
            ], animated: true)
    }
}
