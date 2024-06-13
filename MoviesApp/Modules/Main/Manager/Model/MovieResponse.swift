//
//  MovieResponse.swift
//  MoviesApp
//
//  Created by Admin on 13/06/24.
//

import Foundation

struct MovieResponse: Codable {
    let id: Int?
    let title: String?
    let adult: Bool?
    let originalLengauge: String?
    let vote_average: Double?
    
}
