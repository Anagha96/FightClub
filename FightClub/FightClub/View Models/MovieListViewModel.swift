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
    var filteredMovieList = Dynamic(defaultMovieList)
    var selectedMovie: Int?
    var apiManager = APIManager.shared
    
    /// Creating MovieListViewCellModel for each movie
    func createMovieListViewCellModels(for movies: [Movie]) {
        self.movieList.value = movies.map {
            return MovieListViewCellModel.createMovieListCellViewModel(for: $0)
        }
    }
    
    /// Fetch All movies
    func fetchMovies(completion: @escaping ((Error?) -> Void)) {
        apiManager.initiateRequest(for: .movieList) { (model: MovieList?, error) in
            if error == nil {
                if let model = model {
                    DataManager.shared.movies = model.results
                    createMovieListViewCellModels(for: DataManager.shared.movies)
                    completion(nil)
                } else {
                    completion(error)
                }
            }
        }
    }
    
    /// Filtering the movies based on the searchText 
    mutating func filterMovies(for searchText: String?) {
        if let searchText = searchText {
            let searchHandler = SearchHandler(searchString: searchText)
            filteredMovieList.value = movieList.value.filter { (movie) -> Bool in
                return searchHandler.matches(movie.name.value)
            }
        }
    }
}



