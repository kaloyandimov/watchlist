//
//  Movie.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 1.03.22.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let releaseDate: String
    let overview: String
    let voteAverage: Double
    
    let runtime: Int?
    let posterPath: String?
    let backdropPath: String?
    let genres: [Genre]?
}
