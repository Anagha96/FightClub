//
//  MovieListViewModel.swift
//  FightClub
//
//  Created by Anagha Wadkar on 24/04/21.
//

import Foundation

public struct MovieListViewModel {
    private static let defaultMovieList: [MovieListViewCellModel] = []
    var movieList = Dynamic(defaultMovieList)
    
    var apiManager = APIManager.shared
    
    /// Creating MovieListViewCellModel for each movie
    func createMovieListViewCellModels() {
        self.movieList.value = DataManager.shared.movies.map {
            return MovieListViewCellModel.createMovieListCellViewModel(for: $0)
        }
    }
    
    
    /// Fetch All movies
    func fetchMovies(completion: @escaping ((Error?) -> Void)) {
        apiManager.initiateRequest(for: .movieList) { (model: MovieList?, error) in
            if error == nil {
                if let model = model {
                    DataManager.shared.movies = model.results
                    createMovieListViewCellModels()
                    completion(nil)
                } else {
                    completion(error)
                }
            }
        }
    }
}

