//
//  GetMoviesMock.swift
//  MoviesAppTests
//
//  Created by Lesly Higuera on 15/06/24.
//

import Foundation
@testable import MoviesApp

class MockMainManager: MainManager {
    var shouldReturnError = false
    
    override func getMovies(url: String, page: Int, isSearching: Bool, query: String, completionHandler completion: @escaping ((Result<MoviesResponse, Error>) -> Void)) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error fetching movies"])))
        } else {
            let response = MoviesResponse(results: [MovieResponse(id: 0, genreIds: [1], title: "title", originalTitle: "originalTitle", adult: false, originalLanguage: "originalLanguage", voteAverage: 5.0, overview: "overview", imageUrl: "imageUrl", releaseDate: "releaseDate")])
            completion(.success(response))
        }
    }
    
}
