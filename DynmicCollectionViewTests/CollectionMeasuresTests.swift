//
//  DynmicCollectionViewTests.swift
//  DynmicCollectionViewTests
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

@testable import DynmicCollectionView
import XCTest

final class CollectionMeasuresTests: XCTestCase {
    private let accuracy: CGFloat = 0.0000001
    private let constants = MockedMeasures()
    private var measures: CollectionMeasures!
    override func setUpWithError() throws {
        measures = CollectionMeasures(screenWidth: 400, measures: constants)
        measures.insertRow()
    }

    func testCellSizeWhenAddRemoveCell() throws {
        XCTAssertEqual(measures.columnWidths[0], 100)
        XCTAssertEqual(measures.columnWidths[1], 100)
        XCTAssertEqual(measures.columnWidths[2], 100)
        XCTAssertEqual(measures.height(for: .init(position: 0)), constants.defaultRowHeight)
    }

    func testScaleCellWidthByPinch() throws {
        measures.updateCellSizeScale(for: .init(position: 1), scale: 1.1)
        XCTAssertEqual(measures.columnWidths[1], 110,
                       accuracy: accuracy)
        XCTAssertEqual(measures.columnWidths[0], 190 / 2,
                       accuracy: accuracy)
        XCTAssertEqual(measures.columnWidths[2], 190 / 2,
                       accuracy: accuracy)

        measures.updateCellSizeScale(for: .init(position: 1), scale: 1.2)
        XCTAssertEqual(measures.columnWidths[1], 132,
                       accuracy: accuracy)

        measures.updateCellSizeScale(for: .init(position: 1), scale: 1.2)
        XCTAssertEqual(measures.columnWidths[1], 140,
                       accuracy: accuracy)
        XCTAssertEqual(measures.columnWidths[0], constants.defaultColumnWidth,
                       accuracy: accuracy)
    }

    func testScaleCellToHeightWhenTextChanged() throws {
        let change = measures.set(height: 196, for: 2, with: 4)
        XCTAssertTrue(change)
        XCTAssertEqual(measures.height(for: .init(position: 0)), 200, accuracy: accuracy)
        XCTAssertEqual(measures.height(for: .init(position: 1)), 200, accuracy: accuracy)
        XCTAssertEqual(measures.height(for: .init(position: 2)), 200, accuracy: accuracy)

        let updateUI = measures.set(height: 196, for: 2)
        XCTAssertFalse(updateUI)
    }

    func testScaleCellWidthCantExceedMinimuimWidthToOtherColumns() throws {
        measures.updateCellSizeScale(for: .init(position: 1), scale: 1.5)
        XCTAssertEqual(measures.columnWidth(for: .init(position: 1)), 140,
                       accuracy: accuracy)
        XCTAssertEqual(measures.columnWidth(for: .init(position: 0)), 80,
                       accuracy: accuracy)

        XCTAssertEqual(measures.columnWidth(for: .init(position: 2)), 80,
                       accuracy: accuracy)

        XCTAssertEqual(measures.columnWidths.reduce(0, +), 300,
                       accuracy: accuracy)
    }

    func testReversedScaleFactorForOtherCells() {
        XCTAssertEqual(measures.unScaleValue(scale: 1.1), 0.95, accuracy: accuracy)
        XCTAssertEqual(measures.unScaleValue(scale: 0.9), 1.05)
        XCTAssertEqual(measures.unScaleValue(scale: 0.9590133436675166), 1.02049332817, accuracy: accuracy)
    }

    func testTranslateSpaceFactorForOtherCells() {
        // Increase size
        XCTAssertEqual(measures.translate(scale: 1.05, for: .init(position: 0), source: .init(position: 1)), 2.5, accuracy: accuracy)

        XCTAssertEqual(measures.translate(scale: 1.05, for: .init(position: 2), source: .init(position: 1)), -2.5, accuracy: accuracy)
        // Decrease size

        XCTAssertEqual(measures.translate(scale: 0.9, for: .init(position: 0), source: .init(position: 1)), -5, accuracy: accuracy)

        XCTAssertEqual(measures.translate(scale: 0.9, for: .init(position: 2), source: .init(position: 1)), 5, accuracy: accuracy)
    }

    func testSqueezeColumn() {
        measures.squeezeColumn(of: 0, squeeze: true)
        XCTAssertEqual(measures.columnWidth(for: .init(position: 0)), constants.defaultColumnWidth)

        measures.squeezeColumn(of: 0, squeeze: false)
        XCTAssertEqual(measures.columnWidth(for: .init(position: 0)), 140)
    }

    func testSetCellWidthByScaling() {
        measures.updateCellSizeScale(for: .init(position: 1), scale: 1.1)
        XCTAssertEqual(measures.columnWidths[0], 95)
        XCTAssertEqual(measures.columnWidths[1], 110, accuracy: accuracy)
        XCTAssertEqual(measures.columnWidths[2], 95)
    }

    func testReturnDeleteButtonIndexes() {
        XCTAssertEqual(measures.indexesOfDelete(for: 7), [.init(position: 4), .init(position: 5), .init(position: 6), .init(position: 7)])
    }

    func testCanScaleWidth() {
        XCTAssertEqual(measures.canScaleWidth(for: .init(position: 1), scale: 1.4), true)
        XCTAssertEqual(measures.canScaleWidth(for: .init(position: 1), scale: 1.41), false)
    }

    func testDeleteRow() {
        measures.deleteRow(with: 3)
        XCTAssertEqual(measures.heightMatrix.count, 0)
    }

    func testGetIndexPathsInTheSameRow() {
        let indexes: [IndexPath] = (0 ... 20).map { IndexPath(row: $0, section: 0) }
        XCTAssertEqual(measures.indexPathsInTheSameRow(for: 1), Array(indexes[0 ... 2]))
        XCTAssertEqual(measures.indexPathsInTheSameRow(for: 4), Array(indexes[4 ... 6]))
        XCTAssertEqual(measures.indexPathsInTheSameRow(for: 10), Array(indexes[8 ... 10]))
        XCTAssertEqual(measures.indexPathsInTheSameRow(for: 12), Array(indexes[12 ... 14]))
        XCTAssertEqual(measures.indexPathsInTheSameRow(for: 1, excludeMe: true),
                       [IndexPath(position: 0), IndexPath(position: 2)])
    }

    func testOrientationChange() {
        XCTAssertEqual(measures.columnWidths[0], 100)
        measures.update(screenWidth: 700)
        XCTAssertEqual(measures.columnWidths[0], 200)
        XCTAssertEqual(measures.columnWidths[1], 200)
        XCTAssertEqual(measures.columnWidths[2], 200)
    }
}

struct MockedMeasures: MeasuresType {
    func getMargins() -> CGFloat {
        return 100
    }

    let columnsCount = 3
    let defaultRowHeight: CGFloat = 80
    let defaultColumnWidth: CGFloat = 80
    let deleteButtonWidth: CGFloat = 100
    func rowDefaultHeight() -> [CGFloat] {
        return .init(repeating: defaultRowHeight, count: columnsCount)
    }

    func columnMinimuimWidth() -> [CGFloat] {
        return .init(repeating: defaultColumnWidth, count: columnsCount)
    }
}
