//
//  MovieListViewCellModel.swift
//  FightClub
//
//  Created by Anagha Wadkar on 24/04/21.
//

import Foundation
import UIKit

public struct MovieListViewCellModel {
    
    let name = Dynamic("")
    let poster = Dynamic("")
    let releaseDate = Dynamic("")
    let id = Dynamic(0)
    
    /// Creating view model for a movie cell
    static func createMovieListCellViewModel(for movie: Movie) -> MovieListViewCellModel {
        let movieListCellModel = MovieListViewCellModel()
        movieListCellModel.name.value = movie.originalTitle ?? ""
        movieListCellModel.poster.value = movie.posterPath ?? ""
        movieListCellModel.id.value = movie.id ?? 0
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let releaseDate = dateFormatter.date(from: movie.releaseDate ?? "") {
            dateFormatter.dateFormat = "MMM d, yyyy"
            let releaseDateFormattedString = dateFormatter.string(from: releaseDate)
            movieListCellModel.releaseDate.value = releaseDateFormattedString
        }
        return movieListCellModel
    }
}
