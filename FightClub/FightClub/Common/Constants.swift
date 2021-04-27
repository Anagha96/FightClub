//
//  Constants.swift
//  FightClub
//
//  Created by Anagha Wadkar on 25/04/21.
//

import Foundation

struct Constants {
    struct Common{
        static let recentlySearchedMovieskey = "recentlySearchedMovies"
    }
    
    struct MovieList {
        static let movieListCellIdentifier = "movieCell"
        static let movieListCellNibName = "MovieCell"
        static let recentSearchCellIdentifier = "recentSearchCell"
        static let recentSearchCellNibName = "RecentSearchCell"
        static let segueId = "showDetail"
        static let bookButtonPressedAlertTitle = "Book Button Pressed"
        static let bookButtonPressedAlertMsg = "Please tap on 'OK' to continue"
        static let bookButtonPressedAlertActionTitle = "OK"
        static let maxRecentlySearchedMovies = 5
        
    }
    
    struct MovieDetails {
        static let movieDetailsCellId = "movieDetailsCell"
        static let movieDetailsCellNibName = "MovieDetailsCell"
        static let movieReviewsCellIdentifier = "reviewsCell"
        static let movieReviewsCellNibName = "MovieReviewsCell"
        static let movieCrewCellIdentifier = "crewDetailsCell"
        static let movieCrewCellNibName = "CrewDetailsCell"
        static let movieDetailsSectionIdentifier = "movieDetailsSectionHeader"
        static let movieDetailsSectionNibName = "MovieDetailsSectionHeaderView"
        
    }
}

