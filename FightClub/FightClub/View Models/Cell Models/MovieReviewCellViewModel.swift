//
//  MovieReviewCellViewModel.swift
//  FightClub
//
//  Created by Anagha Wadkar on 26/04/21.
//

import Foundation

struct MovieReviewCellViewModel {
    
    var reviewer = Dynamic("")
    var reviewDate = Dynamic("")
    var reviewContent = Dynamic("")
    
    
    
    /// Creating view model for a details cell
    static func createMovieReviewsCellViewModel(for review: Result?) -> MovieReviewCellViewModel {
        let movieReviewsCellModel = MovieReviewCellViewModel()
        movieReviewsCellModel.reviewer.value = review?.author ?? ""
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let reviewDateString = review?.createdAt?.components(separatedBy: "T").first ?? ""
        if let reviewDate = dateFormatter.date(from: reviewDateString ?? "") {
            dateFormatter.dateFormat = "MMM d, yyyy"
            let reviewDateFormattedString = dateFormatter.string(from: reviewDate)
            movieReviewsCellModel.reviewDate.value = reviewDateFormattedString
        }
        movieReviewsCellModel.reviewContent.value = review?.content ?? ""
        return movieReviewsCellModel
    }
}

