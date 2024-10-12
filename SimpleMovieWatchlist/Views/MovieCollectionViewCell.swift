//
//  MovieCollectionViewCell.swift
//  SimpleMovieWatchlist
//
//  Created by Sandor Gyulai on 10/10/2024.
//

import UIKit
import Kingfisher

class MovieCollectionViewCell: UICollectionViewCell {
    static let identifier = "MovieCollectionViewCell"

    let posterImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(posterImageView)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 1.5/1)
        ])

        contentView.layer.cornerRadius = 10
        posterImageView.layer.cornerRadius = 10
    }

    func configure(with movie: Movie) {
        if let posterURL = movie.posterURL {
            posterImageView.kf.setImage(with: posterURL)
        } else {
            posterImageView.image = UIImage(systemName: "film") // Fallback if no image available
        }
    }
}

