//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by Lesly Higuera on 14/06/24.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var originalTitleLabel: UILabel!
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var voteLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    // MARK: - Properties
    
    var movie: MovieResponse? {
        didSet {
            setupView()
        }
    }
    
    private var imageService = ImageService()
    
    // MARK: - Controller lifecycle methods

    override func viewDidLoad() {
        super.viewDidLoad()
        movieImage.layer.cornerRadius = 10
    }
    
    // MARK: - Methods
    
    func setupView() {
        self.view?.downloadImage(imageService: imageService, url: movie?.fullImageUrl ?? "", imageView: movieImage)
        originalTitleLabel.text = movie?.originalTitle
        titleLabel.text = movie?.title
        dateLabel.text = movie?.releaseDate
        voteLabel.text = String(format: "%.2f", movie?.voteAverage ?? 0.0)
        descriptionLabel.text = movie?.overview
    }

}
