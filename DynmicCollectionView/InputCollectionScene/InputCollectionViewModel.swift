//
//  InputCollectionViewModel.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 11.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
final class InputViewModel {
    var newCollectionRow: [CollectionDataItem] { [.input(""), .input(""), .input(""), .delete] }
    var items: [CollectionDataItem] = []
    var currentEditingIndex = -1
    func appendNewRow() {
        items.append(contentsOf: newCollectionRow)
    }

    func delete(at indexes: [Int]) {
        items.removeSubrange(indexes.indices)
    }
}
