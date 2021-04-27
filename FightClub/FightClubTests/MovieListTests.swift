//
//  MovieListViewModelTests.swift
//  FightClubTests
//
//  Created by Anagha Wadkar on 24/04/21.
//

import XCTest
@testable import FightClub

class MovieListViewModelTests: XCTestCase {
    var viewModel = MovieListViewModel()
    
    func testFetchMovies() {
        viewModel.apiManager = MockAPIManager(with: Bundle(for: MovieListViewModelTests.self))
        viewModel.fetchMovies { (err) in
            XCTAssertEqual(DataManager.shared.movies.count, 2)
        }
        XCTAssertEqual(DataManager.shared.movies.first?.originalTitle, "Godzilla vs. Kong")
        XCTAssertEqual(DataManager.shared.movies.first?.originalLanguage, "en")
        XCTAssertEqual(DataManager.shared.movies.first?.adult, false)
    }
}

class MovieListCellViewModelTests: XCTestCase {

    func testCreateMovieListCellViewModel() {
        let bundle = Bundle(for: MovieListViewModelTests.self)
        if let path = bundle.path(forResource: "Movie", ofType: "json"), let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: []) {
            do {
                let decoder = JSONDecoder()
                let model = try decoder.decode(MovieList.self, from: data)
                if let movie = model.results.first {
                    let viewModel = MovieListCellViewModel.createMovieListCellViewModel(for: movie)
                    XCTAssertEqual(viewModel.name.value, "Godzilla vs. Kong")
                    XCTAssertEqual(viewModel.releaseDate.value, "Mar 24, 2021")
                }
            } catch {
                
            }
        }
    }

}
