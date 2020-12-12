//
//  InputCollectionViewModel.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 11.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
protocol InputViewModelType {
    var items: [CollectionDataItem] { get }
    var currentEditingIndex: Int { get }
    func delete(at indexes: [Int])
    func appendNewRow()
    func shouldShowKeypad(at index: Int) -> Bool
    func textChanged(_ text: String, at index: Int)
}

final class InputViewModel: InputViewModelType {
    private var newCollectionRow: [CollectionDataItem] { [.input(""), .input(""), .input(""), .delete] }
    var items: [CollectionDataItem] = []
    var currentEditingIndex = -1
    func appendNewRow() {
        items.append(contentsOf: newCollectionRow)
    }

    func delete(at indexes: [Int]) {
        items.removeSubrange(indexes.indices)
    }

    func shouldShowKeypad(at index: Int) -> Bool {
        return index == currentEditingIndex
    }

    func textChanged(_ text: String, at index: Int) {
        currentEditingIndex = index
        items[index] = .input(text)
    }
}
