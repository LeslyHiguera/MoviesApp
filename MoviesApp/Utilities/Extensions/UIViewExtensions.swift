//
//  UIViewExtensions.swift
//  MoviesApp
//
//  Created by Admin on 14/06/24.
//

import UIKit

extension UIView {
    
    func downloadImage(imageService: ImageService, url: String, imageView: UIImageView) {
        guard let url = URL(string: url) else { return }
        imageService.image(for: url) { image in
            imageView.image = image
        }
    }
    
}
