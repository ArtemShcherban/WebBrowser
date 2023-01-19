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
        delegate?.reloadCurrentWebpage()
    }
    
    func textFieldShouldBeginEditing(_: UITextField) -> Bool {
        delegate?.addressBarWillBeginEditing(self)
        return true
    }
    
    func textFieldDidBeginEditing(_: UITextField) {
        delegate?.addressBarDidBeginEditing()
    }
    
    func textFieldShouldReturn(_: UITextField) -> Bool {
        addressBarText = textField.text
        showInactiveStyle()
        delegate?.addressBar(self, didReturnWithText: addressBarText ?? "")
        return true
    }
    
    func textFieldDidEndEditing(_: UITextField) {
        textField.text = addressBarText
        containerView.bringSubviewToFront(domainLabel)
        showInactiveStyle()
    }
}
