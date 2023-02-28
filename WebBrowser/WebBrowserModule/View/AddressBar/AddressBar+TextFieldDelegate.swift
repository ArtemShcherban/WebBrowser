//
//  AddressBar+TextFieldDelegate.swift
//  WebBrowser
//
//  Created by Artem Shcherban on 19.01.2023.
//

import UIKit

extension AddressBar: TextFieldDelegate {
    func textFieldTextHasChanged() {
        domainLabel.text = textField.text
    }
    
    func reloadButtonTapped() {
        controller?.reloadCurrentWebsite()
    }
    
    func textFieldShouldBeginEditing(_: UITextField) -> Bool {
        controller?.addressBarWillBeginEditing(self)
        return true
    }
    
    func textFieldDidBeginEditing(_: UITextField) {
        isActive = true
    }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        addressBarText = textField.text
        showInactiveStyle()
        controller?.addressBar(self, didReturnWithText: addressBarText ?? "")
        return true
    }
    
    func textFieldDidEndEditing(_: UITextField) {
        textField.text = addressBarText
        containerView.bringSubviewToFront(domainLabel)
        showInactiveStyle()
    }
}
