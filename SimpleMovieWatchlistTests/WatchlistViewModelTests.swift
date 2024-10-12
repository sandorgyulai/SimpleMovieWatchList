//
//  WatchlistViewModelTests.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 11/10/2024.
//

import XCTest
@testable import SimpleMovieWatchlist

class WatchlistViewModelTests: XCTestCase {

    var viewModel: WatchlistViewModel!
    var mockMovie = Movie(id: 1, title: "Movie 1", overview: "Overview 1", releaseDate: "1111-11-11", posterPath: nil)

    override func setUp() {
        super.setUp()
        viewModel = WatchlistViewModel()
        UserDefaults.standard.removeObject(forKey: "watchlist")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "watchlist")
        super.tearDown()
    }

    func testAddToWatchlist() {

        viewModel.addToWatchlist(movie: mockMovie)

        XCTAssertTrue(viewModel.isMovieInWatchlist(movie: mockMovie))
        XCTAssertEqual(viewModel.watchlist.count, 1)
    }

    func testRemoveFromWatchlist() {

        viewModel.addToWatchlist(movie: mockMovie)
        viewModel.removeFromWatchlist(movie: mockMovie)

        XCTAssertFalse(viewModel.isMovieInWatchlist(movie: mockMovie))
        XCTAssertEqual(viewModel.watchlist.count, 0)
    }

    func testAddDuplicateMovie() {

        viewModel.addToWatchlist(movie: mockMovie)
        viewModel.addToWatchlist(movie: mockMovie)

        XCTAssertEqual(viewModel.watchlist.count, 1)
    }

    func testLoadWatchlistFromUserDefaults() {

        viewModel.addToWatchlist(movie: mockMovie)

        let newViewModel = WatchlistViewModel()
        
        XCTAssertTrue(newViewModel.isMovieInWatchlist(movie: mockMovie))
        XCTAssertEqual(newViewModel.watchlist.count, 1)
    }
}
