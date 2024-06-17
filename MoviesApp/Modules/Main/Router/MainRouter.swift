//
//  MainRouter.swift
//  MoviesApp
//
//  Created by Lesly Higuera on 17/06/24.
//

import UIKit

class MainRouter {
    
    // MARK: - Properties
    
    weak var view: MainViewController?
    
    // MARK: - Methods
    
    func goToDescription(movie: MovieResponse) {
        let vc = MovieDetailsViewController()
        vc.movie = movie
        vc.modalTransitionStyle = .flipHorizontal
        view?.present(vc, animated: true)
    }
    
}
