//
//  MovieList.swift
//  FightClub
//
//  Created by Anagha Wadkar on 24/04/21.
//

import Foundation

// MARK: - MovieList Codable Model
struct MovieList: Codable {
    let dates: Dates?
    let page: Int?
    let results: [Movie]
    let totalPages, totalResults: Int?
    
    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Dates: Codable {
    let maximum, minimum: String?
}

// MARK: - Movie Codable Model
struct Movie: Codable {
    let adult: Bool?
    let posterPath: String?
    let backdropPath: String?
    let genreIDS: [Int?]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, releaseDate: String?
    let overview: String?
    let popularity: Double?
    let title: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?
    
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
}
