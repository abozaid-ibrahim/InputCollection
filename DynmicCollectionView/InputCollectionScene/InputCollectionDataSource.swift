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
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InputCollectionCell.reuseIdentifier, for: indexPath) as! InputCollectionCell
        cell.set(text: items[indexPath.row],
                 onDoubleTap: { [weak self] in
                     guard let self = self else { return }
                     self.heightEditor.setRowExpanded(for: indexPath, expand: true)
                     self.reloadRow(row: indexPath.row)
                 },
                 onPinch: { [weak self] recognizer in
                     guard let self = self else { return }
                     switch recognizer.state {
                     case .began, .changed:
                         self.animator.animate(cell: cell, at: indexPath, with: recognizer.scale)
                     case .ended:
                        self.headerView.updateLabelsWidth(with: self.heightEditor.columnWidths)
                        self.collectionView.reloadData()//reloadRow(row: indexPath.row)
                     default:
                         print("")
                     }
                 })

        cell.textView.tag = indexPath.row
        cell.textView.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row == currentEditingIndex,
              let cell = cell as? InputCollectionCell else { return }
        cell.textView.becomeFirstResponder()
    }
}

extension InputCollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.heightEditor.cellSize(for:indexPath)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
