//
//  MovieListViewModel.swift
//  FightClub
//
//  Created by Anagha Wadkar on 24/04/21.
//

import Foundation

public struct MovieListViewModel {
    private static let defaultMovieList: [MovieListCellViewModel] = []
    private static let defaultRecentsList: [RecentSearchCellViewModel] = []
    var movieList = Dynamic(defaultMovieList)
    var recentlySearchedMovies = Dynamic(defaultRecentsList)
    var filteredMovieList = Dynamic(defaultMovieList)
    var selectedMovie: Int?
    var apiManager = APIManager.shared
    
    
    
    /// Creating MovieListViewCellModel for each movie
    func createMovieListViewCellModels(for movies: [Movie]) {
        self.movieList.value = movies.map {
            return MovieListCellViewModel.createMovieListCellViewModel(for: $0)
        }
    }
    
    ///Save Recently SearchedData
    func saveToRecentlySearched(movieID: Int?) {
        print("Cached Movies", DataManager.shared.recentlySearchedMovies)
        guard let movieID = movieID else {
            return
        }
        /// If movie already present return
        guard !DataManager.shared.recentlySearchedMovies.contains(movieID) else {
            return
        }
        if DataManager.shared.recentlySearchedMovies.count >= Constants.MovieList.maxRecentlySearchedMovies {
            /// Remove Oldest Recent Movie if count more than maxRecentlySearchedMovies allowed
            DataManager.shared.recentlySearchedMovies.removeFirst()
            DataManager.shared.recentlySearchedMovies.append(movieID)
        } else {
            DataManager.shared.recentlySearchedMovies.append(movieID)
        }
    }
    
    func createRecentlySearchedViewCellModels() {
        let filteredMovies = DataManager.shared.movies.filter { (movie) in
            if let id = movie.id {
                return DataManager.shared.recentlySearchedMovies.contains(id)
            } else {
                return false
            }
        }
        self.recentlySearchedMovies.value = filteredMovies.map {
            return RecentSearchCellViewModel.createRecentSearchCellViewModel(for: $0)
        }
    }
    
    /// Fetch All movies
    func fetchMovies(completion: @escaping ((Error?) -> Void)) {
        apiManager.initiateRequest(for: .movieList) { (model: MovieList?, error) in
            if error == nil {
                if let model = model {
                    DataManager.shared.movies = model.results
                    createMovieListViewCellModels(for: DataManager.shared.movies)
                    createRecentlySearchedViewCellModels()
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



