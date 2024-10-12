//
//  MovieListViewModel.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 10/10/2024.
//

import Foundation

class MovieListViewModel {

    private let apiService: TMDBServiceProtocol

    private(set) var movies: [Movie] = [] {
        didSet {
            self.didUpdateMovies?()
        }
    }

    private(set) var errorMessage: String? {
        didSet {
            self.didUpdateErrorMessage?()
        }
    }

    var didUpdateMovies: (() -> Void)?
    var didUpdateErrorMessage: (() -> Void)?

    init(apiService: TMDBServiceProtocol = TMDBAPI()) {
        self.apiService = apiService
        Task {
            await fetchPopularMovies() // Fetch popular movies by default
        }
    }

    func fetchPopularMovies() async {
        let result = await apiService.fetchPopularMovies()
        switch result {
        case .success(let movies):
            self.movies = movies
        case .failure(let error):
            self.errorMessage = "Failed to load popular movies: \(error.localizedDescription)"
        }
    }

    func searchMovies(query: String) async {
        let result = await apiService.searchMovies(query: query)
        switch result {
        case .success(let movies):
            self.movies = movies
        case .failure(let error):
            self.errorMessage = "Failed to search movies: \(error.localizedDescription)"
        }
    }
}

