//
//  SimpleMovieWatchlistTests.swift
//  SimpleMovieWatchlistTests
//
//  Created by Sandor Gyulai on 10/10/2024.
//

import XCTest
@testable import SimpleMovieWatchlist

final class MockTMDBService: TMDBServiceProtocol {

    var mockMovies: [Movie]?
    var mockError: Error?

    func fetchPopularMovies() async -> Result<[Movie], Error> {
        if let error = mockError {
            return .failure(error)
        }
        return .success(mockMovies ?? [])
    }

    func searchMovies(query: String) async -> Result<[Movie], Error> {
        if let error = mockError {
            return .failure(error)
        }
        return .success(mockMovies ?? [])
    }

    enum APIError: Error {
        case noData
    }
}
