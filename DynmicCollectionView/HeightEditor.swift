//
//  HeightEditor.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 06.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

final class HeightEditor {
    private var heights: [[CGFloat]] = [[33, 44, 4]]
    private var forcedCollapseRows: [Int: Bool] = [:]
    private let minimuimCellHeight: CGFloat = 60
    private var expandedModeEnabled = true
    static let shared = HeightEditor()

    func height(for index: IndexPath) -> CGFloat {
        guard expandedModeEnabled else {
            return minimuimCellHeight
        }
        guard let itemExist = forcedCollapseRows[row(for: index)] else {
            return heights[row(for: index)].max() ?? 0
        }
        return itemExist ? minimuimCellHeight : heights[row(for: index)].max() ?? 0
    }

    func set(height: CGFloat, for index: IndexPath) {
        let r = row(for: index)
        let c = column(for: index)
        guard heights[r][c] != height else { return }
        heights[r][c] = height
    }

    func expandAllCells(_ expand: Bool) {
        expandedModeEnabled = expand
    }

    func setRowExpanded(for indexPath: IndexPath, expand: Bool) {
        expandedModeEnabled = expand
        forcedCollapseRows[row(for: indexPath)] = !expand
    }

    func row(for index: IndexPath) -> Int {
        return index.row / 3
    }

    func column(for index: IndexPath) -> Int {
        return index.row % 3
    }
}
