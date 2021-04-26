//
//  MovieDetailsCellViewModel.swift
//  FightClub
//
//  Created by Anagha Wadkar on 26/04/21.
//

import Foundation

struct MovieDetailsCellViewModel {
    
    var tagLine = Dynamic("")
    var backDrop = Dynamic("")
    var movieName = Dynamic("")
    var infoDetails = Dynamic("")
    var overview = Dynamic("")
    
    
    /// Creating view model for a details cell
    static func createMovieDetailsCellViewModel(for synopsis: Synopsis?) -> MovieDetailsCellViewModel {
        let movieDetailsCellModel = MovieDetailsCellViewModel()
        movieDetailsCellModel.backDrop.value = synopsis?.backdropPath ?? ""
        movieDetailsCellModel.movieName.value = synopsis?.originalTitle ?? ""
        movieDetailsCellModel.infoDetails.value = ""
        movieDetailsCellModel.tagLine.value = synopsis?.tagline ?? ""
        movieDetailsCellModel.overview.value = synopsis?.overview ?? ""
        
        var genresString = ""
        if let genres = synopsis?.genres {
            for genre in genres {
                genresString += ((genre.name ?? "") + ",")
            }
        }
        genresString = String(genresString.dropLast())
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let releaseDate = dateFormatter.date(from: synopsis?.releaseDate ?? "") {
            dateFormatter.dateFormat = "MMM d, yyyy"
            let releaseDateFormattedString = dateFormatter.string(from: releaseDate)
            movieDetailsCellModel.infoDetails.value = "\(releaseDateFormattedString) • \(genresString)"
        }
        
        return movieDetailsCellModel
    }
}

