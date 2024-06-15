//
//  GetMoviesMock.swift
//  MoviesAppTests
//
//  Created by Admin on 15/06/24.
//

import Foundation
@testable import MoviesApp

class MockMainManager: MainManager {
    var shouldReturnError = false
    
    override func getMovies(page: Int, category: MoviesCategory, completionHandler completion: @escaping (Result<MoviesResponse, Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error fetching movies"])))
        } else {
            let response = MoviesResponse(results: [MovieResponse(id: 0, genreIds: [1], title: "title", originalTitle: "originalTitle", adult: false, originalLanguage: "originalLanguage", voteAverage: 5.0, overview: "overview", imageUrl: "imageUrl", releaseDate: "releaseDate")])
            completion(.success(response))
        }
    }
    
    override func searchMovies(query: String, page: Int, completionHandler completion: @escaping ((Result<MoviesResponse, Error>) -> Void)) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error fetching movies"])))
        } else {
            let response = MoviesResponse(results: [MovieResponse(id: 0, genreIds: [1], title: "title", originalTitle: "originalTitle", adult: false, originalLanguage: "originalLanguage", voteAverage: 5.0, overview: "overview", imageUrl: "imageUrl", releaseDate: "releaseDate")])
            completion(.success(response))
        }
    }
}
