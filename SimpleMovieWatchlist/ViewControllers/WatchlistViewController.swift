//
//  WatchlistViewController.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 10/10/2024.
//

import UIKit

class WatchlistViewController: UIViewController, UICollectionViewDelegate {

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

    private let watchlistViewModel: WatchlistViewModel
    private var collectionView: UICollectionView!

    init(watchlistViewModel: WatchlistViewModel) {
        self.watchlistViewModel = watchlistViewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Watchlist"
        setupUI()
        bindViewModel()
    }

    // MARK: - ViewModel Binding
    
    private func bindViewModel() {
        watchlistViewModel.didUpdateWatchlist = { [weak self] in
            DispatchQueue.main.async {
                self?.applySnapshot(movies: self?.watchlistViewModel.watchlist ?? [])
            }
        }
        applySnapshot(movies: watchlistViewModel.watchlist) // Load watchlist data initially
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
        let selectedMovie = watchlistViewModel.watchlist[indexPath.row]
        let detailVC = MovieDetailViewController(movie: selectedMovie, watchlistViewModel: watchlistViewModel)
        navigationController?.pushViewController(detailVC, animated: true)
    }

}

// MARK: - UI Setup

extension WatchlistViewController {

    private func setupUI() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: .movieGridLayout)
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = dataSource
        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
