//
//  APIManager.swift
//  MoviesApp
//
//  Created by Admin on 15/06/24.
//

import Foundation

struct APIRouter {
    
    var path: String {
        "https://api.themoviedb.org"
    }
    
    var page: Int {
        didSet(newValue) {
            page = newValue
        }
    }
    
    var query: String = "" {
        didSet(newValue) {
            query = newValue
        }
    }
    
    var popularUrl: String {
        return path + "/3/movie/popular?page=\(page)&api_key=\(Constants().apiKey)"
    }
    
    var topRatedUrl: String {
        return path + "/3/movie/top_rated?page=\(page)&api_key=\(Constants().apiKey)"
    }
    
    var searchUrl: String {
        return path + "/3/search/movie?page=\(page)&api_key=\(Constants().apiKey)&query=\(query)"
    }
    
}
