//
//  WatchlistViewModel.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 10/10/2024.
//

import Foundation

// MARK: - WatchlistViewModel

class WatchlistViewModel {

    private let userDefaultsKey = "watchlist"
    private(set) var watchlist: [Movie] = [] {
        didSet {
            saveWatchlist()
            self.didUpdateWatchlist?()
        }
    }

    var didUpdateWatchlist: (() -> Void)?

    init() {
        loadWatchlist()
    }

    func addToWatchlist(movie: Movie) {
        if !watchlist.contains(where: { $0.id == movie.id }) {
            watchlist.append(movie)
        }
    }

    func removeFromWatchlist(movie: Movie) {
        watchlist.removeAll { $0.id == movie.id }
    }

    func isMovieInWatchlist(movie: Movie) -> Bool {
        return watchlist.contains { $0.id == movie.id }
    }

    // MARK: - Persistence with UserDefaults
    // For task purposes as this is not sensitive data.
    private func saveWatchlist() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(watchlist) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    private func loadWatchlist() {
        if let savedWatchlist = UserDefaults.standard.object(forKey: userDefaultsKey) as? Data {
            let decoder = JSONDecoder()
            if let decodedWatchlist = try? decoder.decode([Movie].self, from: savedWatchlist) {
                watchlist = decodedWatchlist
            }
        }
    }
}
