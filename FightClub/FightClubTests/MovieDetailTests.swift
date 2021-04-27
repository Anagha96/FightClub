//
//  MovieDetailTests.swift
//  FightClubTests
//
//  Created by Anagha Wadkar on 27/04/21.
//

import XCTest
@testable import FightClub

class MovieDetailViewModelTests: XCTestCase {
    var viewModel = MovieDetailViewModel()
    
    func testFetchMovieDetails() {
        let exp = expectation(description: "Wait for response")
        viewModel.apiManager = MockAPIManager(with: Bundle(for: MovieListViewModelTests.self))
        viewModel.fetchMovieDetails(id: 12345) { (err) in
            XCTAssertNil(err)
            
            XCTAssertEqual(self.viewModel.movieList.value.count, 2)
            XCTAssertEqual(self.viewModel.movieList.value.first?.releaseDate.value, "Dec 15, 1984")
            XCTAssertEqual(self.viewModel.movieList.value.first?.name.value, "ゴジラ")
            XCTAssertEqual(self.viewModel.movieList.value.first?.poster.value, "/tpv62T04n2Q5sw1WtiDbJzwQXSI.jpg")
            
            XCTAssertEqual(self.viewModel.crewList.value.count, 2)
            XCTAssertEqual(self.viewModel.crewList.value.first?.characterName.value, "Dr. Nathan Lind")
            XCTAssertEqual(self.viewModel.crewList.value.first?.name.value, "Alexander Skarsgård")
            
            XCTAssertEqual(self.viewModel.movieReviews.value.count, 3)
            XCTAssertEqual(self.viewModel.movieReviews.value.first?.reviewer.value, "garethmb")
            XCTAssertEqual(self.viewModel.movieReviews.value.first?.reviewDate.value, "Apr 22, 2021")
            
            XCTAssertEqual(self.viewModel.movieDetails.value.first?.movieName.value, "Godzilla vs. Kong")
            XCTAssertEqual(self.viewModel.movieDetails.value.first?.tagLine.value, "One Will Fall")
            XCTAssertEqual(self.viewModel.movieDetails.value.first?.infoDetails.value, "Mar 24, 2021 • Action,Science Fiction")

            exp.fulfill()
        }
        wait(for: [exp], timeout: 2.0)
    }
}
