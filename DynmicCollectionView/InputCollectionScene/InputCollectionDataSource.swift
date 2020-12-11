//
//  CollectionDataSource.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension InputCollectionController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.items[indexPath.row] {
        case .delete:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DeleteCell.identifier, for: indexPath) as! DeleteCell
            cell.set(onTap: { [weak self] in self?.delete(row: indexPath.row) })
            return cell
        case let .input(text):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InputCollectionCell.reuseIdentifier, for: indexPath) as! InputCollectionCell
            cell.set(text: text,
                     onDoubleTap: { [weak self] in self?.squeese(row: indexPath.row) },
                     onPinch: { [weak self] recognizer in self?.scale(cell: cell, at: indexPath, with: recognizer) })
            cell.textView.tag = indexPath.row
//            cell.textView.delegate = self
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        guard indexPath.row == viewModel.currentEditingIndex,
//              let cell = cell as? InputCollectionCell else { return }
//        cell.textView.becomeFirstResponder()
    }
}

private extension InputCollectionController {
    func delete(row: Int) {
        let indexes = measures.indexesOfDelete(for: row)
        measures.deleteRow(with: row)
        viewModel.delete(at: indexes.map { $0.row })
        collectionView.deleteItems(at: indexes)
        collectionView.reloadData()
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
            print(">> \(recognizer)")
        }
    }
}

extension InputCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return measures.cellSize(for: indexPath, isDeleteCell: viewModel.items[indexPath.row] == .delete)
    }
}
