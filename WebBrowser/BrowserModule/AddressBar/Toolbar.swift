//
//  Toolbar.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 03.12.2022.
//

import UIKit

final class Toolbar: UIToolbar {
    enum Position {
        case top
        case bottom
    }
    
    var position: Position = .bottom
    private(set) lazy var goBackButton = UIBarButtonItem()
    private(set) lazy var goForwardButton = UIBarButtonItem()
    lazy var heartButton = UIBarButtonItem()
    lazy var plusButton = UIBarButtonItem()
    lazy var listButton = UIBarButtonItem()
    lazy var addTabButton: UIBarButtonItem? = {
        Interface.orientation == .portrait ? nil : UIBarButtonItem()
    }()
    private lazy var flexibleSpace = UIBarButtonItem(
        barButtonSystemItem: .flexibleSpace,
        target: nil,
        action: nil
    )
    private lazy var fixedSpace: UIBarButtonItem = {
        let fixedSpace = UIBarButtonItem(
            barButtonSystemItem: .fixedSpace,
            target: nil,
            action: nil
        )
        fixedSpace.width = Interface.screenWidth * 0.55
        return fixedSpace
    }()
    
    init(position: Position) {
        self.position = position
        super.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        disableButtons()
        setupButtonImage()
        setBarButtonItems()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
private extension Toolbar {
    func disableButtons() {
        goBackButton.isEnabled = false
        goForwardButton.isEnabled = false
        heartButton.isEnabled = false
    }
    
    func setBarButtonItems() {
        position == .top ? setButtonItemsForTopToolbar() : setButtonItemsForBottomToolbar()
    }
    
    func setupButtonImage() {
        let weightConfiguration = UIImage.SymbolConfiguration(weight: .semibold)
        goBackButton.image = UIImage(
            systemName: "chevron.left.circle", withConfiguration: weightConfiguration
        )
        goForwardButton.image = UIImage(
            systemName: "chevron.right.circle", withConfiguration: weightConfiguration
        )
        heartButton.image = UIImage(
            systemName: "heart", withConfiguration: weightConfiguration
        )
        addTabButton?.image = UIImage(
            systemName: "plus", withConfiguration: weightConfiguration
        )
        plusButton.image = UIImage(
            systemName: "plus.circle", withConfiguration: weightConfiguration
        )
        listButton.image = UIImage(
            systemName: "list.bullet", withConfiguration: weightConfiguration
        )
    }
    
    func setButtonItemsForBottomToolbar() {
        setItems(
            [
                flexibleSpace,
                goBackButton,
                flexibleSpace,
                goForwardButton,
                flexibleSpace,
                heartButton,
                flexibleSpace,
                plusButton,
                flexibleSpace,
                listButton,
                flexibleSpace
            ], animated: true)
    }
    
    func setButtonItemsForTopToolbar() {
        guard let addTabButton else { return }
        setItems(
            [
                goBackButton,
                flexibleSpace,
                goForwardButton,
                flexibleSpace,
                heartButton,
                fixedSpace,
                addTabButton,
                flexibleSpace,
                plusButton,
                flexibleSpace,
                listButton
            ], animated: true)
    }
}
