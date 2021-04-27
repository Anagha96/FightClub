//
//  MovieDetailViewModel.swift
//  FightClub
//
//  Created by Anagha Wadkar on 26/04/21.
//

import Foundation

public struct MovieDetailViewModel {
    
    private static let defaultCrewList: [CrewDetailsCellViewModel] = []
    private static let defaultMovieList: [MovieListCellViewModel] = []
    private static let defaultDetails: [MovieDetailsCellViewModel] = []
    private static let defaultReviews: [MovieReviewCellViewModel] = []
    
    var movieReviews = Dynamic(defaultReviews)
    var movieDetails = Dynamic(defaultDetails)
    var movieList = Dynamic(defaultMovieList)
    var crewList = Dynamic(defaultCrewList)
    
    var apiManager = APIManager.shared
    
    func createCrewDetailsCellViewModels(for crew: [Cast]) {
        self.crewList.value = crew.map {
            return CrewDetailsCellViewModel.createMovieListCellViewModel(for: $0)
        }
    }
    
    /// Creating MovieListViewCellModel for each movie
    func createMovieListViewCellModels(for movies: [Movie]) {
        self.movieList.value = movies.map {
            return MovieListCellViewModel.createMovieListCellViewModel(for: $0)
        }
    }
    
    func createMovieDetailsViewCellModel(for synopsis: Synopsis) {
        self.movieDetails.value = [MovieDetailsCellViewModel.createMovieDetailsCellViewModel(for: synopsis)]
    }
    func createMovieReviewsViewCellModel(for reviews: [Result]) {
        self.movieReviews.value = reviews.map {
            return MovieReviewCellViewModel.createMovieReviewsCellViewModel(for: $0)
        }
    }
    
    /// Fetch Details of a movie
    func fetchMovieDetails(id: Int?, completion: @escaping ((Error?) -> Void)) {
        guard let id = id else {
            return
        }
        let group = DispatchGroup()
        var err: Error?
        group.enter()
        apiManager.initiateRequest(for: .credits(id: id)) { (model: Credits?, error) in
            if error == nil {
                if let model = model {
                    createCrewDetailsCellViewModels(for: model.cast ?? [])
                } else {
                    err = error
                }
            }
            group.leave()
        }
        
        group.enter()
        apiManager.initiateRequest(for: .similarMovies(id: id)) { (model: SimilarMovies?, error) in
            if error == nil {
                if let model = model {
                    createMovieListViewCellModels(for: model.results ?? [])
                } else {
                    err = error
                }
            }
            group.leave()
        }
        group.enter()
        apiManager.initiateRequest(for: .synopsis(id: id)) { (model: Synopsis?, error) in
            if error == nil {
                if let model = model {
                    createMovieDetailsViewCellModel(for: model)
                } else {
                    err = error
                }
            }
            group.leave()
        }
        
        group.enter()
        apiManager.initiateRequest(for: .reviews(id: id)) { (model: Reviews?, error) in
            if error == nil {
                if let model = model {
                    createMovieReviewsViewCellModel(for: model.results ?? [])
                } else {
                    err = error
                }
            }
            group.leave()
        }
        
        group.notify(queue: .main) {
            if let err = err {
                completion(err)
            } else {
                completion(nil)
            }
        }
    }
}
