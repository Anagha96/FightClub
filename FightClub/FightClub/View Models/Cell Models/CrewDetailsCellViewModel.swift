//
//  CrewDetailsCellModel.swift
//  FightClub
//
//  Created by Anagha Wadkar on 26/04/21.
//

import Foundation

struct CrewDetailsCellViewModel {
    let name = Dynamic("")
    let characterName = Dynamic("")
    let profileImage = Dynamic("")
    
    
    /// Creating view model for a crew cell
    static func createMovieListCellViewModel(for cast: Cast?) -> CrewDetailsCellViewModel {
        let crewCellModel = CrewDetailsCellViewModel()
        crewCellModel.name.value = cast?.name ?? ""
        crewCellModel.characterName.value = cast?.character ?? ""
        crewCellModel.profileImage.value = cast?.profilePath ?? ""
        return crewCellModel
    }
}
