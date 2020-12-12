//
//  UIColor+App.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 11.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static var themeLightGray: UIColor {
        if #available(iOS 13, *) {
            return UIColor.systemGray6
        } else {
            return UIColor.lightGray.withAlphaComponent(0.2)
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
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    return UIColor.black
                } else {
                    return UIColor.white
                }
            }
        } else {
            return UIColor.white
        }
    }
}
