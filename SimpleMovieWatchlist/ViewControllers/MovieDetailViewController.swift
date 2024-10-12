//
//  MovieDetailViewController.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 10/10/2024.
//

import UIKit
import Kingfisher

class MovieDetailViewController: UIViewController {

    private let movie: Movie
    private let viewModel: MovieDetailViewModel

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let releaseDateLabel = UILabel()
    private let watchlistButton = UIButton()

    init(movie: Movie, watchlistViewModel: WatchlistViewModel) {
        self.movie = movie
        self.viewModel = MovieDetailViewModel(watchlistViewModel: watchlistViewModel)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureMovieDetails()
    }

    // MARK: - Configure Movie Details

    private func configureMovieDetails() {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        releaseDateLabel.text = "Release Date: \(movie.releaseDate ?? "N/A")"

        if let posterURL = movie.posterURL {
            posterImageView.kf.setImage(with: posterURL)
        } else {
            posterImageView.image = UIImage(systemName: "film")
        }
        updateWatchlistButton()
    }

    // MARK: - Watchlist Management

    private func updateWatchlistButton() {
        if viewModel.isMovieInWatchlist(movie: movie) {
            watchlistButton.setTitle("Remove from Watchlist", for: .normal)
            watchlistButton.backgroundColor = .systemRed
        } else {
            watchlistButton.setTitle("Add to Watchlist", for: .normal)
            watchlistButton.backgroundColor = .systemBlue
        }
    }

    @objc private func toggleWatchlist() {
        viewModel.toggleWatchlistStatus(for: movie)
        updateWatchlistButton()
    }
}

// MARK: - UI Setup

extension MovieDetailViewController {

    private func setupUI() {
        view.backgroundColor = .systemBackground

        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(overviewLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(watchlistButton)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        setupPosterImageView()
        setupTitleLabel()
        setupReleaseDateLabel()
        setupOverviewLabel()
        setupWatchlistButton()
    }

    private func setupPosterImageView() {
        posterImageView.contentMode = .scaleAspectFit
        posterImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            posterImageView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }

    private func setupTitleLabel() {
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.numberOfLines = 0
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    private func setupReleaseDateLabel() {
        releaseDateLabel.font = UIFont.systemFont(ofSize: 14)
        releaseDateLabel.textColor = .gray
        releaseDateLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            releaseDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])
    }

    private func setupOverviewLabel() {
        overviewLabel.font = UIFont.systemFont(ofSize: 16)
        overviewLabel.numberOfLines = 0
        overviewLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            overviewLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 10),
            overviewLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20)
        ])
    }

    private func setupWatchlistButton() {
        watchlistButton.setTitle("Add to Watchlist", for: .normal)
        watchlistButton.backgroundColor = .systemBlue
        watchlistButton.setTitleColor(.white, for: .normal)
        watchlistButton.layer.cornerRadius = 8
        watchlistButton.translatesAutoresizingMaskIntoConstraints = false
        watchlistButton.addTarget(self, action: #selector(toggleWatchlist), for: .touchUpInside)

        NSLayoutConstraint.activate([
            watchlistButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 20),
            watchlistButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            watchlistButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            watchlistButton.heightAnchor.constraint(equalToConstant: 50),
            watchlistButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }

}
