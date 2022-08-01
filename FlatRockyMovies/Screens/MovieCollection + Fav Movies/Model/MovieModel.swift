//
//  MovieModel.swift
//  FlatRockyMovies
//
//  Created by Gaga Nizharadze on 29.07.22.
//

import Foundation

struct MovieResponse: Codable {
    let page: Int?
    let results: [Movie]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}


struct Movie: Codable, Identifiable, Hashable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage, originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let video: Bool?
    let voteAverage: Double
    let voteCount: Int?
    var isFavourite: Bool?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }

    
    var backdropURLString: String {
        return "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")"
    }
    
    var posterURLString: String {
        return  "https://image.tmdb.org/t/p/w500\(posterPath ?? "")"
    }
    
    
    
    var ratingText: String {
        let rating = Int(voteAverage)
        let ratingText = (0 ..< (rating / 2)).reduce("") { (acc, _) -> String in
            return acc + "⭐️"
        }
        return ratingText
    }
}


