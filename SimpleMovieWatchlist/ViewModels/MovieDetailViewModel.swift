//
//  MovieDetailViewModel.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 10/10/2024.
//

import Foundation

// MARK: - MovieDetailViewModel

class MovieDetailViewModel {
    
    private var watchlistViewModel: WatchlistViewModel

    init(watchlistViewModel: WatchlistViewModel) {
        self.watchlistViewModel = watchlistViewModel
    }
    
    func toggleWatchlistStatus(for movie: Movie) {
        if watchlistViewModel.isMovieInWatchlist(movie: movie) {
            watchlistViewModel.removeFromWatchlist(movie: movie)
        } else {
            watchlistViewModel.addToWatchlist(movie: movie)
        }
    }
    
    func isMovieInWatchlist(movie: Movie) -> Bool {
        return watchlistViewModel.isMovieInWatchlist(movie: movie)
    }
}
