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
    static let defaultRowHeight: CGFloat = 730
    static let defaultColumnWidth: CGFloat = 100
}

final class CollectionMeasures {
    private let shouldPreserveRatio = true
    private let screenWidth: CGFloat
    init(screenWidth: CGFloat) {
        self.screenWidth = screenWidth
    }

    private(set) lazy var columnWidths: [CGFloat] = .init(repeating: self.screenWidth / CGFloat(Measures.columnsCount), count: Measures.columnsCount)
    private lazy var heightList: [[CGFloat]] = [rowDefaultHeight]
    private lazy var rowDefaultHeight: [CGFloat] = .init(repeating: Measures.defaultRowHeight, count: Measures.columnsCount)
    private lazy var columnMinimuimWidth: [CGFloat] = .init(repeating: Measures.defaultColumnWidth, count: Measures.columnsCount)
    private var forcedCollapseRows: [Int: Bool] = [:]
    private var expandedModeEnabled = true

    func insertRow() {
        heightList.append(rowDefaultHeight)
    }

    func height(for index: IndexPath) -> CGFloat {
        guard expandedModeEnabled else {
            return Measures.defaultRowHeight
        }
        guard let itemExist = forcedCollapseRows[row(for: index)] else {
            return heightList[row(for: index)].max() ?? 0
        }
        return itemExist ? Measures.defaultRowHeight : heightList[row(for: index)].max() ?? 0
    }

    func set(height: CGFloat, for position: Int) -> Bool {
        let r = row(for: .init(position: position))
        let c = column(for: .init(position: position))
        guard heightList[r][c] != height else {
            return false
        }
        heightList[r][c] = height
        return true
    }

    func expandAllCells(_ expand: Bool) {
        expandedModeEnabled = expand
    }

    func setRowExpanded(for indexPath: IndexPath, expand: Bool) {
        expandedModeEnabled = expand
        forcedCollapseRows[row(for: indexPath)] = !expand
    }

    func allowedWidth(for column: Int) -> CGFloat {
        let cellsMinimuim = columnMinimuimWidth.reduce(0, +) - columnMinimuimWidth[column]
        return screenWidth - cellsMinimuim
    }

    func canScaleWidth(for indexPath: IndexPath, scale: CGFloat) -> Bool {
        let col = column(for: indexPath)
        let newWidth = columnWidths[col] * scale
        let maxWidth = allowedWidth(for: col)
        let minWidth = columnMinimuimWidth[col]
        return (newWidth <= maxWidth) && (newWidth >= minWidth)
    }

    func updateCellSizeScale(for indexPath: IndexPath, scale: CGFloat) -> Bool {
        expandedModeEnabled = true
        let col = column(for: indexPath)
        var newWidth = columnWidths[col] * scale

        let maxWidth = allowedWidth(for: col)
        newWidth = newWidth <= maxWidth ? newWidth : maxWidth

        let minWidth = columnMinimuimWidth[col]
        newWidth = newWidth >= minWidth ? newWidth : minWidth
        for i in 0 ..< columnWidths.count {
            if col == i {
                columnWidths[i] = newWidth
            } else {
                columnWidths[i] = (screenWidth - newWidth) / CGFloat(Measures.columnsCount - 1)
            }
        }
//        let h = height(for: indexPath)
//        set(height: h * scale, for: indexPath.row)
        return true
    }

    func columnWidth(for index: IndexPath) -> CGFloat {
        return columnWidths[column(for: index)]
    }

    // 0,1,2,3..
    func row(for indexPath: IndexPath) -> Int {
        return indexPath.row / Measures.columnsCount
    }

    // 0,1,2
    func column(for index: IndexPath) -> Int {
        return index.row % Measures.columnsCount
    }

    // tested
    func indexPathsInTheSameRow(for index: Int) -> [IndexPath] {
        let base = index - (index % 3)
        return (0 ..< Measures.columnsCount).map { IndexPath(row: $0 + base, section: 0) }
    }

    func cellSize(for indexPath: IndexPath) -> CGSize {
        return .init(width: columnWidth(for: indexPath) - 0.01,
                     height: height(for: indexPath))
    }
}
