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
    private let accuracy: CGFloat = 0.001
    private var measures: CollectionMeasures!
    override func setUpWithError() throws {
        measures = CollectionMeasures(screenWidth: 300)
    }

    func testCellSizeWhenAddRemoveCell() throws {
        XCTAssertEqual(measures.columnWidths[0], 100)
        XCTAssertEqual(measures.columnWidths[1], 100)
        XCTAssertEqual(measures.columnWidths[2], 100)
        XCTAssertEqual(measures.height(for: .init(position: 0)), Measures.defaultRowHeight)
    }

    func testScaleCellToMaxWidth() throws {
        measures.updateCellSizeScale(for: .init(position: 1), scale: 1.1)
        XCTAssertEqual(measures.columnWidths[1], 110,
                       accuracy: accuracy)
        XCTAssertEqual(measures.columnWidths[0], 190 / 2,
                       accuracy: accuracy)
        XCTAssertEqual(measures.columnWidths[2], 190 / 2,
                       accuracy: accuracy)
        XCTAssertEqual(measures.height(for: .init(position: 1)), 33,
                       accuracy: accuracy)

        measures.updateCellSizeScale(for: .init(position: 1), scale: 1.2)
        XCTAssertEqual(measures.columnWidths[1], 132,
                       accuracy: accuracy)
        XCTAssertEqual(measures.height(for: .init(position: 1)), 33 * 1.2,
                       accuracy: accuracy)

        measures.updateCellSizeScale(for: .init(position: 1), scale: 1.2)
        XCTAssertEqual(measures.columnWidths[1], 140,
                       accuracy: accuracy)
        XCTAssertEqual(measures.height(for: .init(position: 1)), 47.52,
                       accuracy: accuracy)
    }

    func testScaleCellWidthCantExceedMinimuimWidthToOtherColumns() throws {
        measures.updateCellSizeScale(for: .init(position: 1), scale: 1.4)
        XCTAssertEqual(measures.columnWidths[1], 140,
                       accuracy: accuracy)
        XCTAssertEqual(measures.height(for: .init(position: 1)), 30 * 1.4,
                       accuracy: accuracy)

        measures.updateCellSizeScale(for: .init(position: 1), scale: 1.1)
        XCTAssertEqual(measures.columnWidth(for: .init(position: 1)), 140,
                       accuracy: accuracy)
        XCTAssertEqual(measures.columnWidth(for: .init(position: 0)), 80,
                       accuracy: accuracy)

        XCTAssertEqual(measures.columnWidth(for: .init(position: 2)), 80,
                       accuracy: accuracy)

        XCTAssertEqual(measures.height(for: .init(position: 1)), 30 * 1.4 * 1.1,
                       accuracy: accuracy)
        XCTAssertEqual(measures.columnWidths.reduce(0, +), 300,
                       accuracy: accuracy)
    }

    func testGetIndexPathsInTheSameRow() {
        let indexes: [IndexPath] = (0 ... 20).map { IndexPath(row: $0, section: 0) }
        XCTAssertEqual(measures.indexPathsInTheSameRow(for: 1),  Array(indexes[0...2]))
        XCTAssertEqual(measures.indexPathsInTheSameRow(for: 3),  Array(indexes[3...5]))
        XCTAssertEqual(measures.indexPathsInTheSameRow(for: 19),  Array(indexes[18...20]))
        XCTAssertEqual(measures.indexPathsInTheSameRow(for: 20),  Array(indexes[18...20]))
    }
}
