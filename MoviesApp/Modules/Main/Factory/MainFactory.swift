//
//  MainFactory.swift
//  MoviesApp
//
//  Created by Lesly Higuera on 12/06/24.
//

import UIKit

class MainFactory {

    static func configure() -> UIViewController {
        let manager = MainManager()
        let viewModel = MainViewModel(manager: manager)
        let controller = MainViewController(viewModel: viewModel)
        return controller
    }
    
}
