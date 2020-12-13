//
//  HeightEditor.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 06.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

/// Capture cells size, resize them when text changed, user inputs.
final class CollectionMeasures {
    /// holds the width of the columns which equal to column count
    private(set) lazy var columnWidths: [CGFloat] = .init(repeating: self.screenWidth / CGFloat(measures.columnsCount),
                                                          count: measures.columnsCount)

    /// 2D matrix holds the max height for every single item on the collection view.
    private(set) lazy var heightMatrix: [[CGFloat]] = []
    private(set) var screenWidth: CGFloat
    private var measures: MeasuresType
    init(screenWidth: CGFloat, measures: MeasuresType = Measures()) {
        self.measures = measures
        self.screenWidth = screenWidth - measures.getMargins()
    }

    /// number of items in the same column except the current item.
    private var neighborsCount: CGFloat {
        return CGFloat(measures.columnsCount - 1)
    }

    func update(screenWidth: CGFloat) {
        let previousWidth = self.screenWidth
        self.screenWidth = screenWidth - measures.getMargins()
        let ratio = self.screenWidth / previousWidth
        print(columnWidths)
        for index in 0 ..< columnWidths.count {
            columnWidths[index] = columnWidths[index] * ratio
        }
    }

    func insertRow() {
        heightMatrix.append(measures.rowDefaultHeight())
    }

    func deleteRow(with deleteButtonIndex: Int) {
        heightMatrix.remove(at: row(for: deleteButtonIndex))
    }

    func height(for index: IndexPath) -> CGFloat {
        return heightMatrix[row(for: index.row)].max() ?? 0
    }

    func set(height: CGFloat, for position: Int, with newLineMargin: CGFloat = 4) -> Bool {
        guard heightMatrix[row(for: position)][column(for: position)] != height + newLineMargin else {
            return false
        }
        heightMatrix[row(for: position)][column(for: position)] = height + newLineMargin
        return true
    }

    func squeezeColumn(of position: Int, squeeze: Bool) {
        let index = column(for: position)
        if squeeze {
            let diff = columnWidths[index] - measures.defaultColumnWidth
            columnWidths[index] = measures.defaultColumnWidth
            let expandedIndex = index < (measures.columnsCount - 1) ? index + 1 : index - 1
            columnWidths[expandedIndex] = columnWidths[expandedIndex] + diff
        } else {
            for index in 0 ..< columnWidths.count {
                columnWidths[index] = measures.defaultColumnWidth
            }
            let allItemsWidth = neighborsCount * measures.defaultColumnWidth
            columnWidths[index] = screenWidth - allItemsWidth
        }
    }

    func allowedWidth(for column: Int) -> CGFloat {
        let cellsMinimuim = measures.columnMinimuimWidth().reduce(0, +) - measures.columnMinimuimWidth()[column]
        return screenWidth - cellsMinimuim
    }

    func canScaleWidth(for indexPath: IndexPath, scale: CGFloat) -> Bool {
        let colum = column(for: indexPath.row)
        let newWidth = columnWidths[colum] * scale
        let maxWidth = allowedWidth(for: colum)
        let minWidth = measures.columnMinimuimWidth()[colum]
        return (newWidth <= maxWidth) && (newWidth >= minWidth)
    }

    func unScaleValue(scale: CGFloat) -> CGFloat {
        let one: CGFloat = 1.00
        let diff = abs(scale - one) / neighborsCount
        let scaleFactorForOtherCells = (scale > one) ? one - diff : one + diff
        return scaleFactorForOtherCells 
    }

    func translate(scale: CGFloat, for current: IndexPath, source: IndexPath) -> CGFloat {
        let onLeftSide = current.row < source.row
        let colum = column(for: current.row)
        let newWidth = columnWidths[colum] * scale
        let margin = (newWidth - columnWidths[colum]) / neighborsCount
        return onLeftSide ? margin : -margin
    }

    func widthAfterScale(for indexPath: IndexPath, scale: CGFloat) -> CGFloat {
        let col = column(for: indexPath.row)
        var newWidth = columnWidths[col] * scale

        let maxWidth = allowedWidth(for: col)
        newWidth = newWidth <= maxWidth ? newWidth : maxWidth

        let minWidth = measures.columnMinimuimWidth()[col]
        newWidth = newWidth >= minWidth ? newWidth : minWidth
        return newWidth
    }

    func updateCellSizeScale(for indexPath: IndexPath, scale: CGFloat) {
        let newWidth = widthAfterScale(for: indexPath, scale: scale)
        let otherCellsWidth = (screenWidth - newWidth) / neighborsCount
        for index in 0 ..< columnWidths.count {
            columnWidths[index] = column(for: indexPath.row) == index ? newWidth : otherCellsWidth
        }
    }

    func columnWidth(for index: IndexPath) -> CGFloat {
        return columnWidths[column(for: index.row)]
    }

    func row(for index: Int) -> Int {
        return index / (measures.columnsCount + 1)
    }

    func column(for index: Int) -> Int {
        return index % (measures.columnsCount + 1)
    }

    func indexPathsInTheSameRow(for position: Int, excludeMe: Bool = false) -> [IndexPath] {
        let rowStartIndex = position - column(for: position)
        var indexes = (0 ..< measures.columnsCount).map { IndexPath(position: $0 + rowStartIndex) }
        if excludeMe {
            indexes.removeAll(where: { position == $0.row })
        }
        return indexes
    }

    func indexesOfDelete(for index: Int) -> [IndexPath] {
        return Array(index - measures.columnsCount ... index)
            .map({ IndexPath(position: $0) })
    }

    func cellSize(for indexPath: IndexPath, isDeleteCell: Bool = false) -> CGSize {
        if isDeleteCell {
            return .init(width: measures.deleteButtonWidth,
                         height: measures.deleteButtonWidth)
        } else {
            return .init(width: Int(columnWidth(for: indexPath)),
                         height: Int(height(for: indexPath)))
        }
    }
}
