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
        let toolbar = UIToolbar(frame: .init(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 40)))
        toolbar.items = [doneButton]
        inputAccessoryView = toolbar
    }

    @objc private func hideKeypad(_ sender: Any) {
        endEditing(true)
    }
}
