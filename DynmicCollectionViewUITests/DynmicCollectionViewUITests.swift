//
//  DynmicCollectionViewUITests.swift
//  DynmicCollectionViewUITests
//
//  Created by abuzeid on 04.12.20.
//  Copyright © 2020 abuzeid. All rights reserved.
//

import XCTest

final class DynmicCollectionViewUITests: XCTestCase {
    private let app = XCUIApplication()
    override func setUpWithError() throws {
        continueAfterFailure = true
        app.launch()
    }

    func testAddingDeletingRows() throws {
        let collectionViewsQuery = app.collectionViews
        func assertAddingNewRows() {
            let addButton = app.navigationBars["Input Collection"].buttons["Add"]
            addButton.tap()
            XCTAssertEqual(collectionViewsQuery.children(matching: .cell).count, 8)
        }
        func assertDeleteItems() {
            collectionViewsQuery.children(matching: .cell).element(boundBy: 3).buttons["delete icon"].tap()
            XCTAssertEqual(collectionViewsQuery.children(matching: .cell).count, 4)
        }

        XCTAssertEqual(collectionViewsQuery.children(matching: .cell).count, 4, "No cells shown by default")
        assertAddingNewRows()
        assertDeleteItems()
    }

    func testTypingAndHidingKeyboard() {
        let textView = app.collectionViews.children(matching: .cell)
            .element(boundBy: 0)
            .otherElements
            .children(matching: .textView)
            .element
        textView.tap()
        let userInput = "This text should be in name field after scrolling"
        textView.typeText(userInput)

        XCTAssertTrue(isKeyboardShown)

        app.toolbars["Toolbar"].buttons["Done"]
            .tap()
        app.swipeDown()
        app.swipeUp()
        XCTAssertFalse(isKeyboardShown)
        XCTAssertEqual( textView.value as! String, userInput)
    }

    func testAppGesturesFunctionality() throws {
        let collectionViewsQuery = app.collectionViews

        func assertClickOnHeaderMinimizeColumnWidth() {
            let notesHeader = app.buttons["Notes"]
            notesHeader.doubleTap()
            let oldWidth = notesHeader.frame.width
            XCTAssertLessThanOrEqual(notesHeader.frame.width, oldWidth)
        }
        func assertDoubleTapExpandsCellAndCollapseOthersColumn() {
            let titleTextView = collectionViewsQuery.children(matching: .cell)
                .element(boundBy: 1)
                .otherElements
                .children(matching: .textView)
                .element
            titleTextView.doubleTap()
            XCTAssertLessThan(app.buttons["Notes"].frame.width, titleTextView.frame.width)
            XCTAssertEqual(app.buttons["Name"].frame.width, app.buttons["Notes"].frame.width)
        }
        func assertScalingCell() {
        }

        assertClickOnHeaderMinimizeColumnWidth()
        assertDoubleTapExpandsCellAndCollapseOthersColumn()
    }

    func testAppGesturesScalingCell() throws {
        let nameTextView = app.collectionViews.children(matching: .cell)
            .element(boundBy: 1)
            .otherElements
            .children(matching: .textView).element
        nameTextView.pinch(withScale: 0.9, velocity: -10)
        XCTAssertLessThan(nameTextView.frame.width, app.buttons["Notes"].frame.width)
    }

    private var isKeyboardShown: Bool {
        return app.keyboards.keys.count > 0
    }

    func atestLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
