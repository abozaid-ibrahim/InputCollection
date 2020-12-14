//
//  InputCollectionViewModel.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 11.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
protocol InputViewModelType {
    var currentEditingIndex: Int { get }
    var items: [CollectionDataItem] { get }
    func appendNewRow()
    func deleteRow(with id: UUID) -> [IndexPath]
    func shouldShowKeypad(at index: Int) -> Bool
    func textChanged(_ text: CollectionDataItem, at index: Int)
}

final class InputViewModel: InputViewModelType {
    private var newCollectionRow: [CollectionDataItem] { [.input(text: "", id: UUID()),
                                                          .input(text: "", id: UUID()),
                                                          .input(text: "", id: UUID()),
                                                          .delete(UUID())] }

    var items: [CollectionDataItem] = []
    var currentEditingIndex = -1

    func appendNewRow() {
        items.append(contentsOf: newCollectionRow)
    }

    func deleteRow(with id: UUID) -> [IndexPath] {
        guard let index = items.firstIndex(of: .delete(id)) else { return [] }
        let offset = items.distanceTo(to: index)
        let start = offset - 3
        items.removeSubrange(start ... offset)
        return (start ... offset).map { IndexPath(position: $0) }
    }

    func shouldShowKeypad(at index: Int) -> Bool {
        return index == currentEditingIndex
    }

    func textChanged(_ text: CollectionDataItem, at index: Int) {
        currentEditingIndex = index
        items[index] = text
    }
}
