//
//  UIColor+App.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 11.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

public extension UIColor {
    static var themeLightGray: UIColor {
        if #available(iOS 13, *) {
            return UIColor.systemGray6
        } else {
            return UIColor.lightGray
        }
    }

    static var themeGray: UIColor {
        if #available(iOS 13, *) {
            return UIColor.systemGray5
        } else {
            return UIColor.gray.withAlphaComponent(0.3)
        }
    }

    static var themeWhite: UIColor {
        if #available(iOS 13, *) {
            return UIColor { (collection: UITraitCollection) -> UIColor in
                collection.userInterfaceStyle == .dark ? .black : .white
            }
        } else {
            return UIColor.white
        }
    }
}
