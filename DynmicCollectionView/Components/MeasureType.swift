//
//  MeasureType.swift
//  DynmicCollectionView
//
//  Created by abuzeid on 13.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import Foundation
import UIKit

protocol MeasuresType {
    var columnsCount: Int { get }
    var defaultRowHeight: CGFloat { get }
    var defaultColumnWidth: CGFloat { get }
    var deleteButtonWidth: CGFloat { get }
    func rowDefaultHeight() -> [CGFloat]
    func columnMinimuimWidth() -> [CGFloat]
    func getMargins() -> CGFloat
}

struct Measures: MeasuresType {
    let columnsCount = 3
    let minimumLineSpacing: CGFloat = 1
    let defaultRowHeight: CGFloat = 50
    let defaultColumnWidth: CGFloat = 80
    let deleteButtonWidth: CGFloat = 50
    func getMargins() -> CGFloat {
        return (CGFloat(columnsCount) * minimumLineSpacing) + deleteButtonWidth
    }

    func rowDefaultHeight() -> [CGFloat] {
        return .init(repeating: defaultRowHeight, count: columnsCount)
    }

    func columnMinimuimWidth() -> [CGFloat] {
        return .init(repeating: defaultColumnWidth, count: columnsCount)
    }
}
