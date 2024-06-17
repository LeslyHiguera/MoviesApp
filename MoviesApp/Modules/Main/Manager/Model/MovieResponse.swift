//
//  MovieResponse.swift
//  MoviesApp
//
//  Created by Lesly Higuera on 13/06/24.
//

import Foundation

struct MovieResponse: Codable {
    let id: Int?
    let genreIds: [Int]?
    let title: String?
    let originalTitle: String?
    let adult: Bool?
    let originalLanguage: String?
    let voteAverage: Double?
    let overview: String?
    let imageUrl: String?
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case genreIds = "genre_ids"
        case title
        case originalTitle = "original_title"
        case adult
        case originalLanguage = "original_language"
        case voteAverage = "vote_average"
        case overview
        case imageUrl = "poster_path"
        case releaseDate = "release_date"
        

    }
    
    var fullImageUrl: String? {
        return "https://image.tmdb.org/t/p/w500\(imageUrl ?? "")"
    }

}
