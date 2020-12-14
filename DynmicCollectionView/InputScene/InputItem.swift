//
//  InputItem.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 11.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
enum CollectionDataItem: Hashable {
    case delete(UUID)
    case input(text: String, id: UUID)
    static func == (lhs: Self, rhs: Self) -> Bool {
        switch (lhs, rhs) {
        case let (.delete(id), .delete(id2)),
             let (.input(_, id), .input(_, id2)):
            return id == id2
        default:
            return false
        }
    }

    var isDelete: Bool {
        switch self {
        case .delete:
            return true
        default:
            return false
        }
    }

    private var id: UUID {
        switch self {
        case let .delete(id):
            return id
        case let .input(_, id):
            return id
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
