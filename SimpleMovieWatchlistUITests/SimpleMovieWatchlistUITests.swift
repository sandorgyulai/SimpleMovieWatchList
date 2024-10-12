//
//  SimpleMovieWatchlistUITests.swift
//  SimpleMovieWatchlistUITests
//
//  Created by Sandor Gyulai on 10/10/2024.
//

import XCTest

final class SimpleMovieWatchlistUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        continueAfterFailure = false

        // Pass the launch argument to clear UserDefaults
        app = XCUIApplication()
        app.launchArguments.append("--resetUserDefaults")
        app.launch()
    }

    func testAddAndRemoveFirstPopularMovieToWatchlist() {

        let firstMovieCell = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(firstMovieCell.waitForExistence(timeout: 10))

        firstMovieCell.tap()

        let addToWatchlistButton = app.buttons["Add to Watchlist"]
        XCTAssertTrue(addToWatchlistButton.waitForExistence(timeout: 5))

        addToWatchlistButton.tap()

        let removeFromWatchListButton = app.buttons["Remove from Watchlist"]
        XCTAssertTrue(removeFromWatchListButton.waitForExistence(timeout: 5))
    }

    func testAddMovieToWatchlist() {

        let firstMovieCell = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(firstMovieCell.waitForExistence(timeout: 10))

        firstMovieCell.tap()

        let addToWatchlistButton = app.buttons["Add to Watchlist"]
        XCTAssertTrue(addToWatchlistButton.waitForExistence(timeout: 5))

        addToWatchlistButton.tap()

        let removeFromWatchListButton = app.buttons["Remove from Watchlist"]
        XCTAssertTrue(removeFromWatchListButton.waitForExistence(timeout: 5))

        app.navigationBars.buttons.element(boundBy: 0).tap()

        app.tabBars.buttons["Watchlist"].tap()

        let watchlistFirstMovieCell = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(watchlistFirstMovieCell.waitForExistence(timeout: 5))
    }

    func testRemoveMovieFromWatchlist() {

        let firstMovieCell = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(firstMovieCell.waitForExistence(timeout: 10))
        firstMovieCell.tap()

        let addToWatchlistButton = app.buttons["Add to Watchlist"]
        XCTAssertTrue(addToWatchlistButton.waitForExistence(timeout: 5))

        addToWatchlistButton.tap()

        app.navigationBars.buttons.element(boundBy: 0).tap()
        app.tabBars.buttons["Watchlist"].tap()

        let watchlistFirstMovieCell = app.collectionViews.cells.element(boundBy: 0)
        XCTAssertTrue(watchlistFirstMovieCell.waitForExistence(timeout: 5))

        watchlistFirstMovieCell.tap()

        let removeFromWatchlistButton = app.buttons["Remove from Watchlist"]
        XCTAssertTrue(removeFromWatchlistButton.exists)
        removeFromWatchlistButton.tap()

        app.navigationBars.buttons.element(boundBy: 0).tap()

        XCTAssertFalse(watchlistFirstMovieCell.exists)
    }
}
