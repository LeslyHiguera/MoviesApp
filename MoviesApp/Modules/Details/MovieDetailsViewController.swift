//
//  MovieDetailsViewController.swift
//  MoviesApp
//
//  Created by Lesly Higuera on 14/06/24.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var originalTitleLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //MARK: - Properties
    
    var movie: MovieResponse? {
        didSet {
            setupView()
        }
    }
    
    private var imageService = ImageService()

    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.layer.cornerRadius = 10
    }
    

    func setupView() {
        self.view?.downloadImage(imageService: imageService, url: movie?.fullImageUrl ?? "", imageView: movieImage)
        originalTitleLabel.text = movie?.originalTitle
        titleLabel.text = movie?.title
        dateLabel.text = movie?.releaseDate
        voteLabel.text = String(format: "%.2f", movie?.voteAverage ?? 0.0)
        descriptionLabel.text = movie?.overview
        
    }
    

}
