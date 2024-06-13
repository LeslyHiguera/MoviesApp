//
//  MovieTableViewCell.swift
//  MoviesApp
//
//  Created by Admin on 13/06/24.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    var movie: MovieResponse? {
        didSet {
            setupCell()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Methods
    
    func setupCell() {
        title.text = movie?.title
    }
    
}
