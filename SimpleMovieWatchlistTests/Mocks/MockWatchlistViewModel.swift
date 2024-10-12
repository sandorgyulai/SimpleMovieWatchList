//
//  MockWatchlistViewModel.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 11/10/2024.
//

import XCTest
@testable import SimpleMovieWatchlist

class MockWatchlistViewModel: WatchlistViewModel {
    
    // Local watchlist simulation
    private var mockWatchlist: [Movie] = []

    override func addToWatchlist(movie: Movie) {
        if !mockWatchlist.contains(where: { $0.id == movie.id }) {
            mockWatchlist.append(movie)
        }
    }

    override func removeFromWatchlist(movie: Movie) {
        mockWatchlist.removeAll { $0.id == movie.id }
    }

    override func isMovieInWatchlist(movie: Movie) -> Bool {
        return mockWatchlist.contains { $0.id == movie.id }
    }
}
