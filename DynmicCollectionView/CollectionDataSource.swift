//
//  CollectionDataSource.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

extension CollectionController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EditableCollectionCell.reuseIdentifier, for: indexPath) as! EditableCollectionCell
        cell.set(text: items[indexPath.row],
                 onDoubleTap: {
                     print(">>>Item changed")
                 })

        cell.textView.tag = indexPath.row
        cell.textView.delegate = self
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row == currentEditingIndex,
              let cell = cell as? EditableCollectionCell else { return }
        cell.textView.becomeFirstResponder()
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(">>Did select row")
    }
}

extension CollectionController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let maxHeight = heights[indexPath.row / 3].max() ?? 0
        return .init(width: collectionView.bounds.width / 3, height: maxHeight + 10)
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
