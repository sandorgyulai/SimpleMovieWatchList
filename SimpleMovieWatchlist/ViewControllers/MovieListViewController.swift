//
//  ViewController.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 10/10/2024.
//

import UIKit

class MovieListViewController: UIViewController, UICollectionViewDelegate, UISearchBarDelegate {

    enum Section {
        case main
    }

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Movie>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>

    private lazy var dataSource: DataSource = DataSource(collectionView: collectionView) { collectionView, indexPath, movie in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        cell.configure(with: movie)
        return cell
    }

    var watchlistViewModel: WatchlistViewModel
    private let viewModel = MovieListViewModel()
    private var collectionView: UICollectionView!
    private let searchBar = UISearchBar()

    init(watchlistViewModel: WatchlistViewModel) {
        self.watchlistViewModel = watchlistViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }

    // MARK: - ViewModel Binding

    private func bindViewModel() {
        viewModel.didUpdateMovies = { [weak self] in
            DispatchQueue.main.async {
                self?.applySnapshot(movies: self?.viewModel.movies ?? [])
            }
        }
        applySnapshot(movies: viewModel.movies)  // Load popular movies data initially

        viewModel.didUpdateErrorMessage = { [weak self] in
            DispatchQueue.main.async {
                self?.showErrorAlert(message: self?.viewModel.errorMessage ?? "An unknown error occurred.")
            }
        }
    }

    // MARK: - Show Error Alert
    // Present an error message in an alert view.
    // This is for the task purposes, implementing a less obstrusive empty view for example would be preferable.
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    // MARK: - Apply Snapshot

    private func applySnapshot(movies: [Movie], animatingDifferences: Bool = true) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    // MARK: - UICollectionViewDelegate Methods

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.movies[indexPath.row]
        let detailVC = MovieDetailViewController(movie: selectedMovie, watchlistViewModel: watchlistViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    // MARK: - UISearchBarDelegate Methods

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text, !query.isEmpty else { return }
        searchBar.resignFirstResponder()

        Task {
            await viewModel.searchMovies(query: query)
        }
    }
    
}

// MARK: - UI Setup

extension MovieListViewController {

    private func setupUI() {
        title = "Movies"

        searchBar.delegate = self
        searchBar.placeholder = "Search for Movies"
        searchBar.sizeToFit()
        view.addSubview(searchBar)

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .movieGridLayout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        view.addSubview(collectionView)

        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

}
