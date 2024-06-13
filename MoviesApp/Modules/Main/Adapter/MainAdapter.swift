//
//  MainAdapter.swift
//  MoviesApp
//
//  Created by Admin on 13/06/24.
//

import Foundation
import UIKit

class MainAdapter: NSObject {
    var viewModel: MainViewModel
    
    // MARK: - Observable Properties
    
    var didSelectRowAt: Observable<MovieResponse> {
        mutableDidSelectRowAt
    }
    
    private var mutableDidSelectRowAt = MutableObservable<MovieResponse>()
    
    internal init(viewModel: MainViewModel) {
        self.viewModel = viewModel
    }
}

extension MainAdapter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.mutableDidSelectRowAt.postValue(viewModel.movies[indexPath.row])
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        if maximumOffset - currentOffset <= 10.0 {
            viewModel.page += 1
            viewModel.getPopularMovies()
        }
    }
}

extension MainAdapter: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "movieTableViewCell", for: indexPath) as? MovieTableViewCell {
            cell.movie = viewModel.movies[indexPath.row]
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
