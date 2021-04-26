//
//  ReviewsCollectionViewCell.swift
//  FightClub
//
//  Created by Anagha Wadkar on 26/04/21.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var reviewerNameLabel: UILabel!
    @IBOutlet weak var reviewDate: UILabel!
    @IBOutlet weak var reviewContent: UILabel!
    
    var viewModel: MovieReviewCellViewModel?
    
    func configure() {
        self.viewModel?.reviewer.bind {[weak self] (name) in
            DispatchQueue.main.async {
                self?.reviewerNameLabel.text = name
            }
        }
        self.viewModel?.reviewContent.bind {[weak self] (content) in
            DispatchQueue.main.async {
                self?.reviewContent.text = content
            }
        }
        self.viewModel?.reviewDate.bind {[weak self] (date) in
            DispatchQueue.main.async {
                self?.reviewDate.text = date
            }
        }
    }
}
