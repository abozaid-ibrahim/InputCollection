//
//  KeypadToolbar.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 06.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension UITextView {
    func addDoneButtonToKeypad() {
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(hideKeypad))
        let toolbar = UIToolbar()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolbar.items = [flexSpace, flexSpace, doneButton]
        toolbar.sizeToFit()
        inputAccessoryView = toolbar
    }

    @objc private func hideKeypad(_ sender: Any) {
        endEditing(true)
    }
}
