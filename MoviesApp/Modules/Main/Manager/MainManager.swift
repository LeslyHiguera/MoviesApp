//
//  MainManager.swift
//  MoviesApp
//
//  Created by Admin on 13/06/24.
//

import Foundation

struct Constants {
    let apiKey = "cbda1e4006cc446791a765ae3268895b"
}

struct APIRouter {
    
    var path: String {
        "https://api.themoviedb.org"
    }
    
    var page: Int {
        didSet(newValue) {
            page = newValue
        }
    }
    
    var popularMoviesUrl: String {
        return path + "/3/movie/popular?page=\(page)&api_key=\(Constants().apiKey)"
    }
    
    var topRatedUrl: String {
        return path + "/3/movie/top_rated?page=\(page)&api_key=\(Constants().apiKey)"
    }
    
}

class MainManager {
    
    func getMovies(page: Int, category: MoviesCategory, completionHandler: @escaping ((Result<MoviesResponse, Error>) -> Void)) {
        guard let url = URL(string: category == .popular ? APIRouter(page: page).popularMoviesUrl : APIRouter(page: page).topRatedUrl) else { return }
        URLSession.shared.request(url: url, expecting: MoviesResponse.self) { result in
            switch result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func getTopRatedMovies() {
        
    }
}
