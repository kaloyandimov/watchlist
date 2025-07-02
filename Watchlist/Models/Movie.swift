//
//  Movie.swift
//  Watchlist
//
//  Created by Kaloyan Dimov on 2.07.25.
//

import Foundation

struct Movie: Decodable {
    let id: Int?
    let genres: [Genre]?
    let overview: String?
    let posterPath: String?
    let releaseDate: String?
    let runtime: Int?
    let title: String?
    let voteAverage: Double?
    
    var runtimeToString: String? {
        guard let runtime = runtime else { return nil }
        
        let hours = runtime / 60
        let minutes = runtime % 60;
        
        if (hours == 0) {
            return "\(minutes)m"
        }
        
        if (minutes == 0) {
            return "\(hours)h"
        }
        
        return "\(hours)h \(minutes)m"
    }
    
    var releaseYear: Int? {
        guard let releaseDate = releaseDate else { return nil }
        
        return Int(releaseDate.prefix(4))
    }
}
