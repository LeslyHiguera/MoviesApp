//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Admin on 13/06/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var voteAverageLabel: UILabel!
    
    var movie: MovieResponse? {
        didSet {
            setupCell()
        }
    }
    
    private var imageService = ImageService()

    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    
    func setupCell() {
        self.downloadImage(imageService: imageService, url: movie?.fullImageUrl ?? "", imageView: movieImage)
        titleLabel.text = movie?.title
        releaseDateLabel.text = movie?.releaseDate
        languageLabel.text = movie?.originalLanguage
        voteAverageLabel.text = String(format: "%.2f", movie?.voteAverage ?? 0.0)
    }
    
}
