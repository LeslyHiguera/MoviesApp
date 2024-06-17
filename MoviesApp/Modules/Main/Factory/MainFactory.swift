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
        let router = MainRouter()
        let viewModel = MainViewModel(manager: manager)
        let controller = MainViewController(viewModel: viewModel, router: router)
        router.view = controller
        return controller
    }
    
}
