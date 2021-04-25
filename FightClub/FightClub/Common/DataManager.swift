//
//  DataManager.swift
//  FightClub
//
//  Created by Anagha Wadkar on 24/04/21.
//

import Foundation

// MARK: - Managing Data for the entire application
struct DataManager {
    
    /// Shared instance
    static var shared = DataManager()
    
    var movies: [Movie] = []
    var filteredMovies: [Movie] = []
    
    private init() {}
}

