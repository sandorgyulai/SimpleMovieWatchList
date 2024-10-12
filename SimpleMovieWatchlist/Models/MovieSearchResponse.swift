//
//  MovieSearchResponse.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 10/10/2024.
//

import Foundation

struct MovieSearchResponse: Codable {
    let results: [Movie]
}

struct Movie: Codable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let releaseDate: String?
    let posterPath: String?

    var posterURL: URL? {
        if let posterPath {
            return URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)")
        } else {
            return nil
        }
    }

}
