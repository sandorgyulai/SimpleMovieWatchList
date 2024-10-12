//
//  MovieDetailViewModelTests.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 11/10/2024.
//


import XCTest
@testable import SimpleMovieWatchlist

class MovieDetailViewModelTests: XCTestCase {
    
    var movieDetailViewModel: MovieDetailViewModel!
    var mockWatchlistViewModel: MockWatchlistViewModel!

    var mockMovie = Movie(id: 1, title: "Movie 1", overview: "Overview 1", releaseDate: "1111-11-11", posterPath: nil)

    override func setUp() {
        super.setUp()

        mockWatchlistViewModel = MockWatchlistViewModel()
        movieDetailViewModel = MovieDetailViewModel(watchlistViewModel: mockWatchlistViewModel)
    }

    func testToggleWatchlistStatus_AddMovie() {

        XCTAssertFalse(mockWatchlistViewModel.isMovieInWatchlist(movie: mockMovie))

        movieDetailViewModel.toggleWatchlistStatus(for: mockMovie)

        XCTAssertTrue(mockWatchlistViewModel.isMovieInWatchlist(movie: mockMovie))
    }

    func testToggleWatchlistStatus_RemoveMovie() {

        mockWatchlistViewModel.addToWatchlist(movie: mockMovie)
        XCTAssertTrue(mockWatchlistViewModel.isMovieInWatchlist(movie: mockMovie))

        movieDetailViewModel.toggleWatchlistStatus(for: mockMovie)

        XCTAssertFalse(mockWatchlistViewModel.isMovieInWatchlist(movie: mockMovie))
    }

    func testIsMovieInWatchlist() {

        XCTAssertFalse(movieDetailViewModel.isMovieInWatchlist(movie: mockMovie))

        mockWatchlistViewModel.addToWatchlist(movie: mockMovie)

        XCTAssertTrue(movieDetailViewModel.isMovieInWatchlist(movie: mockMovie))
    }
}
