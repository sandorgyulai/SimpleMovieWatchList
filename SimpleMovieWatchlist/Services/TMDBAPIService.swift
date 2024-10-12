//
//  TMDBAPIService.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 10/10/2024.
//

import Foundation

// MARK: - TMDBAPI Service

protocol TMDBServiceProtocol {
    func fetchPopularMovies() async -> Result<[Movie], Error>
    func searchMovies(query: String) async -> Result<[Movie], Error>
}

class TMDBAPI: TMDBServiceProtocol {
    private let apiKey = "YOUR_API_KEY"
    private let baseURL = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared

    // MARK: - API Methods

    func fetchPopularMovies() async -> Result<[Movie], Error> {
        let url = buildURL(path: "/movie/popular", queryItems: [])
        return await fetchData(from: url, resultType: MovieSearchResponse.self)
            .map(\.results)
    }

    func searchMovies(query: String) async -> Result<[Movie], Error> {
        let url = buildURL(path: "/search/movie", queryItems: [URLQueryItem(name: "query", value: query)])
        return await fetchData(from: url, resultType: MovieSearchResponse.self)
            .map(\.results)
    }

    // MARK: - Helper Methods

    private func buildURL(path: String, queryItems: [URLQueryItem]) -> URL? {
        guard let url = URL(string: baseURL) else {
            return nil
        }

        var components = URLComponents(url: url.appending(path: path), resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "api_key", value: apiKey)] + queryItems
        return components?.url
    }

    private func fetchData<T: Decodable>(from url: URL?, resultType: T.Type) async -> Result<T, Error> {
        guard let url = url else {
            return .failure(APIError.invalidURL)
        }

        do {
            let (data, response) = try await urlSession.data(from: url)

            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                return .failure(APIError.invalidResponse(statusCode: (response as? HTTPURLResponse)?.statusCode ?? -1))
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedResponse = try decoder.decode(T.self, from: data)

            return .success(decodedResponse)
        } catch {
            return .failure(handleError(error))
        }
    }

    private func handleError(_ error: Error) -> APIError {
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .networkUnavailable
            case .timedOut:
                return .networkTimeout
            default:
                return .unknownError
            }
        } else if let decodingError = error as? DecodingError {
            return .decodingFailed(reason: decodingError.localizedDescription)
        } else {
            return .unknownError
        }
    }

    // MARK: - Error Handling
    enum APIError: Error, LocalizedError {
        case invalidURL
        case invalidResponse(statusCode: Int)
        case decodingFailed(reason: String)
        case networkUnavailable
        case networkTimeout
        case unknownError

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Invalid URL."
            case .invalidResponse(let statusCode):
                return "Invalid response from the server. Code: \(statusCode)."
            case .decodingFailed(let reason):
                return "Failed to decode the response JSON: \(reason)."
            case .networkUnavailable:
                return "No internet connection."
            case .networkTimeout:
                return "Request timed out."
            case .unknownError:
                return "An unknown error occurred."
            }
        }
    }
}
