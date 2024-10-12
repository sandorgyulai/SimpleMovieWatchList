//
//  MovieListViewModelTests.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 11/10/2024.
//

import XCTest
@testable import SimpleMovieWatchlist

class MovieListViewModelTests: XCTestCase {

    var viewModel: MovieListViewModel!
    var mockAPIService: MockTMDBService!

    var mockMovies =  [Movie(id: 1, title: "Movie 1", overview: "Overview 1", releaseDate: "1111-11-11", posterPath: nil),
                       Movie(id: 2, title: "Movie 2", overview: "Overview 2", releaseDate: "2222-22-22", posterPath: nil)]

    override func setUp() {
        super.setUp()
        mockAPIService = MockTMDBService()
        viewModel = MovieListViewModel(apiService: mockAPIService)
    }

    func testFetchPopularMoviesSuccess() async throws {
        mockAPIService.mockMovies = mockMovies

        await viewModel.fetchPopularMovies()

        XCTAssertEqual(viewModel.movies.count, 2)
        XCTAssertEqual(viewModel.movies[0].title, "Movie 1")
        XCTAssertEqual(viewModel.movies[1].title, "Movie 2")
    }

    func testFetchPopularMoviesFailure() async throws {

        mockAPIService.mockError = MockTMDBService.APIError.noData
        
        await viewModel.fetchPopularMovies()

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load popular movies: The operation couldn’t be completed. (SimpleMovieWatchlistTests.MockTMDBService.APIError error 0.)")
    }

    func testSearchMoviesSuccess() async throws {

        mockAPIService.mockMovies = mockMovies

        await viewModel.searchMovies(query: "Movie")

        XCTAssertEqual(viewModel.movies.count, 2)
        XCTAssertEqual(viewModel.movies[0].title, "Movie 1")
        XCTAssertEqual(viewModel.movies[1].title, "Movie 2")
    }

    func testSearchMoviesFailure() async throws {

        mockAPIService.mockError = MockTMDBService.APIError.noData

        await viewModel.searchMovies(query: "Movie")

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.errorMessage, "Failed to search movies: The operation couldn’t be completed. (SimpleMovieWatchlistTests.MockTMDBService.APIError error 0.)")
    }

}
