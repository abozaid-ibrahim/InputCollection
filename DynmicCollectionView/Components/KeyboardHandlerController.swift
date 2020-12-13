//
//  KeyboardAutoHandling.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 12.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

public class KeyboardHandlerController: UIViewController {
    var mainScroll: UIScrollView? {
        return nil
    }

    override public func viewDidLoad() {
        super.viewDidLoad()
        subscribeToNotification(UIResponder.keyboardWillShowNotification, selector: #selector(keyboardWillShowOrHide))
        subscribeToNotification(UIResponder.keyboardWillHideNotification, selector: #selector(keyboardWillShowOrHide))
        initializeHideKeyboard()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromAllNotifications()
    }

    public func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }
}

private extension KeyboardHandlerController {
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }

    @objc func keyboardWillShowOrHide(notification: NSNotification) {
        guard let scrollView = mainScroll,
              let userInfo = notification.userInfo,
              let endValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey],
              let durationValue = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey],
              let curveValue = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] else { return }
        let endRect = view.convert((endValue as AnyObject).cgRectValue, from: view.window)
        let keyboardOverlap = scrollView.frame.maxY - endRect.origin.y
        scrollView.contentInset.bottom = keyboardOverlap
        scrollView.scrollIndicatorInsets.bottom = keyboardOverlap
        let duration = (durationValue as AnyObject).doubleValue
        let options = UIView.AnimationOptions(rawValue: UInt((curveValue as AnyObject).integerValue << 16))
        UIView.animate(withDuration: duration ?? 0, delay: 0, options: options, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
