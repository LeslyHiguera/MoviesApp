//
//  MainAdapter.swift
//  MoviesApp
//
//  Created by Lesly Higuera on 13/06/24.
//

import Foundation
import UIKit

class MainAdapter: NSObject {
    
    // MARK: - Properties
    
    var viewModel: MainViewModel
    
    // MARK: - Observable Properties
    
    var didSelectRowAt: Observable<MovieResponse> {
        mutableDidSelectRowAt
    }
    
    private var mutableDidSelectRowAt = MutableObservable<MovieResponse>()
    
    // MARK: - Initializers
    
    internal init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - UITableViewDelegate
extension MainAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mutableDidSelectRowAt.postValue(viewModel.movies[indexPath.row])
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !viewModel.isFiltering {
            let currentOffset = scrollView.contentOffset.y
            let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

            if maximumOffset - currentOffset <= 10.0 {
                viewModel.page += 1
                viewModel.getMovies()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        130
    }
}

// MARK: - UITableViewDataSource
extension MainAdapter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableViewCell", for: indexPath) as? MovieTableViewCell {
            if viewModel.movies.count > 0 {
                cell.movie = viewModel.movies[indexPath.row]
            }
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
