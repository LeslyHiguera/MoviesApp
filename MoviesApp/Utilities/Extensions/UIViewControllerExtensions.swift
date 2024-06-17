//
//  UIViewControllerExtensions.swift
//  MoviesApp
//
//  Created by Lesly Higuera on 14/06/24.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertView.addAction(.init(title: "Ok", style: .default))
        self.present(alertView, animated: true)
    }
    
}
