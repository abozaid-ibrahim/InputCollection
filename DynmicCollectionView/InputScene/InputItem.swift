//
//  InputItem.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 11.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
enum CollectionDataItem: Equatable {
    case delete
    case input(String)
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case (.delete, .delete), (.input, .input):
            return true
        default:
            return false
        }
    }
}
