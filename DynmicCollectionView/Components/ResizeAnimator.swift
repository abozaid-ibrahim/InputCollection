//
//  ResizeAnimator.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 09.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit
protocol ResizeAnimatorType {
    func animate(cell: UIView, at indexPath: IndexPath, with scale: CGFloat)
}

final class ResizeAnimator: ResizeAnimatorType {
    let collectionView: UICollectionView
    let measures: CollectionMeasures
    init(collectionView: UICollectionView,
         measures: CollectionMeasures) {
        self.collectionView = collectionView
        self.measures = measures
    }

    func animate(cell: UIView,
                 at indexPath: IndexPath,
                 with scale: CGFloat) {
        guard measures.canScaleWidth(for: indexPath, scale: scale) else { return }
        let diff = scale - 1.0
        let minimize = diff < 0
        var indexes = measures.indexPathsInTheSameRow(for: indexPath.row)
        indexes.removeAll(where: { indexPath == $0 })
        let unScale = minimize ? 1.0 + abs(diff) : 1.0 - abs(diff)
        for index in indexes {
            let sameRowCell = collectionView.cellForItem(at: index)!
            let onLeftSide = index.row < indexPath.row
            let col = measures.column(for: indexPath)
            let new = measures.columnWidths[col] * scale
            let margin = (new - measures.columnWidths[col]) / 2.0
            sameRowCell.transform = sameRowCell.transform
                .scaledBy(x: unScale, y: 1.0)
                .translatedBy(x: onLeftSide ? -margin : margin, y: 0)
        }
        cell.transform = cell.transform.scaledBy(x: scale, y: 1.0)
        _ = measures.updateCellSizeScale(for: indexPath, scale: scale)
    }
}
