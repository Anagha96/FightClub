//
//  RecentSearchCellViewModel.swift
//  FightClub
//
//  Created by Anagha Wadkar on 27/04/21.
//

import Foundation

struct RecentSearchCellViewModel {
    
    var name = Dynamic("")
    var poster = Dynamic("")
    var id = Dynamic(0)
    
    /// Creating view model for a recently searched cell
    static func createRecentSearchCellViewModel(for movie: Movie) -> RecentSearchCellViewModel {
        let recentSearchedCellModel = RecentSearchCellViewModel()
        recentSearchedCellModel.name.value = movie.originalTitle ?? ""
        recentSearchedCellModel.poster.value = movie.posterPath ?? ""
        recentSearchedCellModel.id.value = movie.id ?? 0
        return recentSearchedCellModel
    }
}
