//
//  MainManager.swift
//  MoviesApp
//
//  Created by Lesly Higuera on 13/06/24.
//

import Foundation

class MainManager {
    
    func getMovies(url: String, page: Int, isSearching: Bool, query: String, completionHandler: @escaping ((Result<MoviesResponse, Error>) -> Void)) {
        guard let url = URL(string: url) else { return }
        URLSession.shared.request(url: url, expecting: MoviesResponse.self) { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }

}
