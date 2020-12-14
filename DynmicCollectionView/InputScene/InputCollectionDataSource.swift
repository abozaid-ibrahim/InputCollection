//
//  CollectionDataSource.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension InputCollectionController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.items[indexPath.row] {
        case let .delete(id):
            let cell = collectionView.dequeue(cell: DeleteCell.self, for: indexPath)
            cell.set(onTap: { [unowned self] in self.deleteRow(with: id) })
            return cell
        case let .input(text, id):
            let cell = collectionView.dequeue(cell: InputCollectionCell.self, for: indexPath)
            cell.set(text: text,
                     onDoubleTap: { [unowned self] in self.squeese(row: indexPath.row) },
                     onPinch: { [unowned self] in self.scale(cell: cell, at: indexPath, with: $0) },
                     onTextChanged: { [unowned self] in self.textDidChange(.input(text: $0, id: id), indexPath, $1) })
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard viewModel.shouldShowKeypad(at: indexPath.row),
              let cell = cell as? InputCollectionCell else { return }
        cell.textView.becomeFirstResponder()
    }
}

private extension InputCollectionController {
    func deleteRow(with id: UUID) {
        let indexes = viewModel.deleteRow(with: id)
        guard let row = indexes.first?.row else {
            return
        }
        measures.deleteRow(with: row)
        collectionView.deleteItems(at: indexes)
    }

    func squeese(row: Int) {
        measures.squeezeColumn(of: row, squeeze: false)
        headerView.updateLabelsWidth(with: measures.columnWidths)
        collectionView.reloadData()
    }

    func scale(cell: UICollectionViewCell, at indexPath: IndexPath, with recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
        case .began, .changed:
            animator.animate(cell: cell, at: indexPath, with: recognizer.scale)
        case .ended:
            headerView.updateLabelsWidth(with: measures.columnWidths)
            collectionView.reloadData()
        default:
            print(" \(recognizer)")
        }
    }

    func textDidChange(_ item: CollectionDataItem, _ index: IndexPath, _ height: CGFloat) {
        viewModel.textChanged(item, at: index.row)
        guard measures.set(height: height, for: index.row) else { return }
        reloadRow(row: index.row)
    }

    func reloadRow(row: Int) {
        UIView.performWithoutAnimation {
            collectionView.reloadItems(at: measures.indexPathsInTheSameRow(for: row))
        }
    }
}

extension InputCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return measures.cellSize(for: indexPath,
                                 isDeleteCell: viewModel.items[indexPath.row].isDelete)
    }
}

extension Collection {
    func distanceTo(to index: Index) -> Int { distance(from: startIndex, to: index) }
}
