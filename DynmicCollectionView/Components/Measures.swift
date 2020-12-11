//
//  HeightEditor.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 06.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

struct Measures {
    static let columnsCount = 3
    static let defaultRowHeight: CGFloat = 100
    static let defaultColumnWidth: CGFloat = 80
    static let deleteButtonWidth: CGFloat = 50
}

// captuer cells height width
// resize them depenign on content and user inputs.
final class CollectionMeasures {
    let screenWidth: CGFloat
    init(screenWidth: CGFloat) {
        self.screenWidth = screenWidth - Measures.deleteButtonWidth
    }

    private(set) lazy var columnWidths: [CGFloat] = .init(repeating: self.screenWidth / CGFloat(Measures.columnsCount), count: Measures.columnsCount)
    private(set) lazy var heightMatrix: [[CGFloat]] = [rowDefaultHeight]
    private lazy var rowDefaultHeight: [CGFloat] = .init(repeating: Measures.defaultRowHeight, count: Measures.columnsCount)
    private lazy var columnMinimuimWidth: [CGFloat] = .init(repeating: Measures.defaultColumnWidth, count: Measures.columnsCount)

    var columnsCountExcludeCurrent: CGFloat {
        return CGFloat(Measures.columnsCount - 1)
    }

    func insertRow() {
        heightMatrix.append(rowDefaultHeight)
    }

    func deleteRow(with deleteButtonIndex: Int) {
        heightMatrix.remove(at: row(for: deleteButtonIndex))
    }

    func height(for index: IndexPath) -> CGFloat {
        return heightMatrix[row(for: index.row)].max() ?? 0
    }

    func set(height: CGFloat, for position: Int) -> Bool {
        let r = row(for: position)
        let c = column(for: position)
        guard heightMatrix[r][c] != height else {
            return false
        }
        heightMatrix[r][c] = height
        return true
    }

    func squeezeColumn(of position: Int, squeeze: Bool) {
        let index = column(for: position)
        if squeeze {
            let diff = columnWidths[index] - Measures.defaultColumnWidth
            columnWidths[index] = Measures.defaultColumnWidth
            let expandedIndex = index < (Measures.columnsCount - 1) ? index + 1 : index - 1
            columnWidths[expandedIndex] = columnWidths[expandedIndex] + diff

        } else {
            for i in 0 ..< columnWidths.count {
                columnWidths[i] = Measures.defaultColumnWidth
            }
            let allItemsWidth = columnsCountExcludeCurrent * Measures.defaultColumnWidth
            columnWidths[index] = screenWidth - allItemsWidth
        }
    }

    func allowedWidth(for column: Int) -> CGFloat {
        let cellsMinimuim = columnMinimuimWidth.reduce(0, +) - columnMinimuimWidth[column]
        return screenWidth - cellsMinimuim
    }

    func canScaleWidth(for indexPath: IndexPath, scale: CGFloat) -> Bool {
        let col = column(for: indexPath.row)
        let newWidth = columnWidths[col] * scale
        let maxWidth = allowedWidth(for: col)
        let minWidth = columnMinimuimWidth[col]
        return (newWidth <= maxWidth) && (newWidth >= minWidth)
    }

    func unScaleValue(scale: CGFloat) -> CGFloat {
        let one: CGFloat = 1.00
        let d = scale > one ? scale - one : one - scale
        let diff = d / columnsCountExcludeCurrent
        let scaleFactorForOtherCells = (scale > one) ? one - diff : one + diff
        return scaleFactorForOtherCells
    }

    func translate(scale: CGFloat, for current: IndexPath, source: IndexPath) -> CGFloat {
        let onLeftSide = current.row < source.row
        let colum = column(for: current.row)
        let newWidth = columnWidths[colum] * scale
        let margin = (newWidth - columnWidths[colum]) / columnsCountExcludeCurrent
        return onLeftSide ? margin : -margin
    }

    func widthAfterScale(for indexPath: IndexPath, scale: CGFloat) -> CGFloat {
        let col = column(for: indexPath.row)
        var newWidth = columnWidths[col] * scale

        let maxWidth = allowedWidth(for: col)
        newWidth = newWidth <= maxWidth ? newWidth : maxWidth

        let minWidth = columnMinimuimWidth[col]
        newWidth = newWidth >= minWidth ? newWidth : minWidth
        return newWidth
    }

    func updateCellSizeScale(for indexPath: IndexPath, scale: CGFloat) {
        let newWidth = widthAfterScale(for: indexPath, scale: scale)
        for i in 0 ..< columnWidths.count {
            if column(for: indexPath.row) == i {
                columnWidths[i] = newWidth
            } else {
                columnWidths[i] = (screenWidth - newWidth) / columnsCountExcludeCurrent
            }
        }
//        let h = height(for: indexPath)
//        set(height: h * scale, for: indexPath.row)
    }

    func columnWidth(for index: IndexPath) -> CGFloat {
        return columnWidths[column(for: index.row)]
    }

    // 0,1,2,3..
    func row(for index: Int) -> Int {
        //
        return index / (Measures.columnsCount + 1)
    }

    // 0,1,2
    func column(for index: Int) -> Int {
        return index % (Measures.columnsCount + 1)
    }

    // tested
    func indexPathsInTheSameRow(for position: Int, excludeMe: Bool = false) -> [IndexPath] {
        let rowStartIndex = position - column(for: position)
        var data = (0 ..< Measures.columnsCount).map { IndexPath(position: $0 + rowStartIndex) }
        if excludeMe {
            data.removeAll(where: { position == $0.row })
        }
        return data
    }

    func indexesOfDelete(for index: Int) -> [IndexPath] {
        return Array(index - Measures.columnsCount ... index)
            .map({ IndexPath(position: $0) })
    }

    func cellSize(for indexPath: IndexPath, isDeleteCell: Bool = false) -> CGSize {
        if isDeleteCell {
            return .init(width: Measures.deleteButtonWidth,
                         height: Measures.deleteButtonWidth)
        } else {
            return .init(width: columnWidth(for: indexPath) - 0.01,
                         height: height(for: indexPath))
        }
    }
}
